%Reinforcement Meta-Learner (RML) class, by massimo silvetti. cf. Silvetti
%et al., 2018. massimo.silvetti@istc.cnr.it
%

classdef RML < handle
    
    properties
        W  %weight matrix
        k %kalman gain
        Temp %temperature
        V  %state-value vector
        D  %prediction error
        sat  %state-action transitions trace
        p %option probability for softmax
        res  %option value
        varD
        varV
        varK
        varV2
        %meta-parameters for K filtering
        alpha
        beta
        eta
        mu
        omega
        gamma
        DAlesion
        NElesion
        HTlesion
        costs
        
    end
    
    methods
        
        function obj=RML(s,a,const)%alpha,beta,eta,mu,omega,gamma,lesion)
            
            obj.k=const.k;
            obj.alpha=const.alpha;
            obj.beta=const.beta;
            obj.eta=const.eta;
            obj.Temp=const.temp;
            obj.gamma=const.gamma;
            obj.omega=const.omega;
            obj.sat=zeros(s,1);
            
            obj.V=zeros(s+1,a);
            obj.V(s+1,:)=0;
            %obj.V(:,3)=0; This causes a default stay option that has to be
            %present.
            obj.costs=const.costs;
            
            obj.D=zeros(s,a);
            obj.varK=zeros(s,a)+0.3;
            obj.varD=zeros(s,a)+0.5;
            obj.varV=zeros(s,a)+0.1;
            obj.varV2=zeros(s,a)+0.5;
            obj.mu=const.mu;
            obj.DAlesion=const.DAlesion;
            obj.NElesion=const.NElesion;
            obj.HTlesion=const.HTlesion;
                       
        end
        
        
        function resp=action(obj,s,a,b)%action selection
            
            a=a';

            obj.p=zeros(1,length(a));
           
            
            obj.res=obj.V(s,a)-obj.costs(s,a)./(b*obj.NElesion);
            
            for i=1:length(a) 
                % Calculate softmax for each option
                obj.p(i)=exp(obj.res(i)/obj.Temp)/(sum(exp(obj.res/obj.Temp))); %p of selecting option 2
            
            end
            resp=randsample([1:length(a)],1,true,obj.p);%select response
            obj.sat(s)=1;%update s-a trace
                  
        end
        
        function p_resp=action_eval(obj,s,a,b,resp)%evaluation of the selected action
            
            a=a';

            obj.p=zeros(1,length(a));
            
            obj.res=obj.V(s,a)-obj.costs(s,a)./(b*obj.NElesion);%max([b*obj.NElesion,1]);
            
            for i=1:length(a) 
                % Calculate softmax for each option
                obj.p(i)=exp(obj.res(i)/obj.Temp)/(sum(exp(obj.res/obj.Temp))); %p of selecting option 2
            
            end
               
            p_resp=obj.p(resp);
                  
        end
        
        
        function KG_update(obj,s,resp)%approximate Kalman Gain

                obj.varD(s,resp)=obj.varD(s,resp)+obj.alpha*(abs(obj.D(s,resp))-obj.varD(s,resp));%overall variance 
          
                obj.varV2(s,resp)=obj.varV2(s,resp)+obj.alpha*((obj.V(s,resp))-obj.varV2(s,resp));%value estimation 
                
                obj.varV(s,resp)=((obj.V(s,resp))-obj.varV2(s,resp)).^2./(obj.varD(s,resp).^2);%value estimation variance/overall variance 
                
                if isnan(obj.varV(s,resp)) || obj.varV(s,resp)<0
                   obj.varV(s,resp)=0;
                elseif isinf(obj.varV(s,resp)) || obj.varV(s,resp)>1
                   obj.varV(s,resp)=1;
                end
                         
                obj.varK(s,resp)=obj.varV(s,resp); % obj.varK(s,resp)
                            
                obj.k=mean(obj.varK(s,:));%LR 
                
                %keep 1 >= k >= eta for numerical stability 
%                 if obj.k>1
%                     obj.k=1;
%                 elseif obj.k<obj.eta
%                     obj.k=obj.eta;
%                 end
                
        end
            
                   
        function VTA=learn(obj,rw,s,s1,resp,RW,b)%outcome analysis and learning           
            
            if obj.omega==0 %if it's ACC Action
                
               R=rw*obj.DAlesion*(RW+(obj.mu*b)); %primary reward boost modulation
               VTA=R+(1-obj.mu)*b*obj.gamma*obj.DAlesion*max(obj.V(s1,:));
               obj.D(s,resp)=VTA-obj.V(s,resp); %TD learning for Action
               
               
            else %if it's ACC Boost
                
               R=rw*RW*obj.DAlesion-obj.omega*b; %primary reward boost cost
               VTA=R+obj.DAlesion*max(obj.V(s1,:));
               obj.D(s,resp)=VTA-obj.V(s,resp); %TD learning for Boost
               
            end
            
            KG_update(obj,s,resp);%LR update
                %keep 1 >= k >= eta for numerical stability 
                if obj.k>1
                    k=1;
                elseif obj.k<obj.eta
                    k=obj.eta;
                else
                    k = obj.k;
                end        
            obj.V(s,resp)=obj.V(s,resp)+(k)*obj.D(s,resp);%value update  
            
        end 
    end
end
            
            
