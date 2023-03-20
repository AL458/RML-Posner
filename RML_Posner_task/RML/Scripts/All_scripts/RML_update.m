%mai call to RML update functions

function [VTA,VTA2]=RML_update(rw,RW,s,s1,b,res,AccAct,AccBoost)

VTA=learn(AccAct,rw,s,s1,res,RW,b);%feedback analysis dACC_Action
VTA2=learn(AccBoost,rw,s,s1,b,RW,b);%feedback analysis dACC_Boost

end