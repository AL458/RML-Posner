%response analysis
function [opt, rw, RW,s1]=resp_analys(arg,trin,se,s,resp,rwlist,rwlistm,trans)

currenv = arg.par.tasks.env{se};

if (currenv.RWM(s,resp)*currenv.RWP(s,resp))==max(currenv.RWM(s,:).*currenv.RWP(s,:))%pascalian optimum
    opt = 1;
else
    opt = 0;
end
    
rw=rwlist(s,resp,trin);
RW=rwlistm(s,resp,trin);

s1=trans(s,resp); %transition based on transition matrix
rw=abs(sign(RW*rw)); %check if there is primary reward 


end