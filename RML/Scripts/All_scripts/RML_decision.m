%main call to RML functions for decision-making

function [b,res]=RML_decision(s,arg,AccAct,AccBoost)

b=action(AccBoost,s,[1:arg.nactions_boost],1);%boost selection. Since there is only one possible boost value, this will always return 1.

res=action(AccAct,s,[1:arg.nactions],b);%action selection

end