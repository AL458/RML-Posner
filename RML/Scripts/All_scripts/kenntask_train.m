
%RML-environment interaction for one training session

function dat=kenntask_train(arg)

%Variables and data structure initialization%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stressenvs = arg.par.tasks.stressenv; % No stress environments in this simulation
nstate=arg.constAct.nstate;
BL = 1;
NTRI= arg.nrun;

%binary reward list, defined separately for each environment
RWLIST=zeros(nstate,length(arg.RWP),NTRI);
RWLISTM=zeros(size(arg.RWM,1),size(arg.RWM,2),NTRI);
RWLISTM_tr=zeros(size(arg.RWM,1),size(arg.RWM,2),arg.ntrial);

% Gets the training blocks
for blnr = 1:size(arg.SEN,2)
    block = arg.SEN(blnr);
    if sum(block == stressenvs)>0
        env = arg.par.tasks.env{arg.par.tasks.trainenv}; % Any  non-stress block
    else
        env = arg.par.tasks.env{block};
    end
    locstart = (blnr-1)*BL+1;
    locend = blnr*BL;
    for i=1:size(env.RWP,2)
        for s=1:nstate
            RWLIST(s,i,locstart:locstart+round(env.RWP(s,i)*BL)-1)=1;
            RWLIST(s,i,locstart:locend)=RWLIST(s,i,randperm(BL)+locstart-1);
        end
    end

%reward list magnitude
    for i=1:size(env.RWM,2)
        for j=1:nstate
            RWLISTM(j,i,locstart:locend)=env.RWM(j,i)+randn(1,BL)*env.rwvar(j,i).^.5;
        end
    end
    % Not used in the training
    env_train = arg.par.tasks.env{arg.par.tasks.trainenv};
    for i=1:size(env_train.RWM,2)
        for j=1:arg.constAct.nstate
            RWLISTM_tr(j,i,locstart:locend)=env_train.RWM(j,i)+randn(1,BL)*env_train.rwvar(j,i).^.5;
        end
    end
end

%data structure storing all events
dat.se=zeros(NTRI,1); %statistical environment 1=Stat;2=Stat2;3=Vol
dat.blck=zeros(NTRI,1); %block number
dat.ttype=zeros(NTRI,1); %trial type
dat.respside=zeros(nstate,NTRI); %response side
dat.optim=zeros(nstate,NTRI); %response optimality in terms of rw probability
dat.rw=zeros(nstate,NTRI); %reward 1=yes
dat.RW=zeros(nstate,NTRI); %reward size
dat.V=zeros(nstate,NTRI,arg.nactions);
dat.V2=zeros(nstate,NTRI,arg.nactions_boost);
dat.D=zeros(nstate,NTRI);
dat.k=zeros(nstate,NTRI);
dat.k2=zeros(nstate,NTRI);
dat.varD=zeros(nstate,NTRI);
dat.varV=zeros(nstate,NTRI);
dat.varV2=zeros(nstate,NTRI);
dat.VTA=zeros(nstate,NTRI);
dat.VTA2=zeros(nstate,NTRI);
dat.loglik = zeros(nstate,NTRI);
dat.b=zeros(nstate,NTRI);
dat.RT = zeros(nstate,NTRI);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RML(nstate,arg.nactions,arg.constAct);
AccBoost=RML(nstate,arg.nactions_boost,arg.constBoost); % Initialized with only one possible boost value, thus not used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initial weights
AccAct.V(1:nstate,:)=arg.W3;
AccBoost.V(1:nstate,:)=arg.We3;

%add noise to initial s-a values
AccAct.V(1:nstate,:)=AccAct.V(1:nstate,:)+randn(nstate,arg.nactions)*.05.*AccAct.V(1:nstate,:);
AccBoost.V(1:nstate,:)=AccBoost.V(1:nstate,:)+randn(nstate,arg.nactions_boost)*.05.*AccBoost.V(1:nstate,:);

trial=1;%trials counter


for se=1
    for tri=1:NTRI
        s = 1; % Only train on valid/invalid cues
        dat.ttype(trial) = s;

        %Set costs for the RML equal for each option.

        AccAct.costs=arg.par.tasks.env{se}.cost;
        RWM=RWLISTM;

        while s<=nstate %within trial state transitions

            %%%%%RML action selection%%%%%% b=boost, res=motor response.
            %%%%%Boost is always set to 1, resulting in a simpler version
            %%%%%of the RML.
            [b,res]=RML_decision(s,arg,AccAct,AccBoost);
            loglik=log(action_eval(AccAct,s,[1:arg.nactions],b,res));

            %%%%%environment analyzes the response by dCC_Action and
            %%%%%provides outcome (that can be a primary reward, a
            %%%%%state transition or both). S1 = next state
            [opt, rw, RW, s1]=resp_analys(arg,trial,se,s,res,RWLIST,RWM,arg.trans);
            if rand(1)<0.8
                congruence = 1;
            else
                congruence = 0;
            end

            if ~(res == 1)
                congruence = -congruence; % If focussing on the opposite side, switch congruent and incongruent
            end

            [unit,RT,side] = get_RT(congruence,b+arg.par.RT.proficiency);
            if unit(side)>unit(3-side) % If correct decision
                rw = 1;
            else
                rw = 0;
            end
            if s==1
                RW = (230-RT)/30;%+randn(1)*0.05;
            else
                RW = (230-RT)/30;%+randn(1)*0.05;
            end
            RT = RT+arg.par.RT.add*10;
            %RML updates; VTA=VTA-to-AccAct, VTA2=VTA-to-AccBoost
            [VTA,VTA2]=RML_update(rw,RW,s,s1,b,res,AccAct,AccBoost);

            %%%record events
            dat.se(trial)=se; %statistical environment 1=Stat;2=Stat2;3=Vol
            dat.blck(trial)=block; %block number                             
            dat.respside(s,trial)=res; %response side
            dat.optim(s,trial)=opt; %response optimality in terms of rw probability                    
            dat.rw(s,trial)=rw; %reward 1=yes         
            dat.RW(s,trial)=RW; %reward 1=yes           
            dat.VTA(s,trial)=VTA;
            dat.VTA2(s,trial)=VTA2;                       
            dat.V(:,trial,:)=AccAct.V(1:nstate,:);
            dat.V2(:,trial,:)=AccBoost.V(1:nstate,:);
            dat.D(s,trial)=abs(AccAct.D(s,res));
            dat.k(s,trial)=(AccAct.k);
            dat.k2(s,trial)=(AccBoost.k);
            dat.varD(s,trial)=mean(AccAct.varD(s,res));
            dat.varK(s,trial)=mean(AccAct.varK(s,res));
            dat.varV(s,trial)=mean(AccAct.varV(s,res));
            dat.varV2(s,trial)=mean(AccAct.varV2(s,res));
            dat.b(s,trial)=b;
            dat.loglik(s,trial)=loglik;
            dat.RT(s,trial)= RT;
            dat.unit(s,trial,:)=unit;
            dat.side(s,trial)=side;
            dat.cong(s,trial)=congruence;
            s=s1; %update state

        end

        %update trial counter
        trial=trial+1;

    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% eval(['save S' num2str(subID) ' dat']);

end









