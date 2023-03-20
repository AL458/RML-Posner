function arg = unpack_loc(loc,arg)
%   Unpacks the loc variables and put them in the arg variable
% Starts by setting act empty, and putting all variables of interest there
arg.constAct.temp = loc(4);
arg.constAct.k = loc(5);
arg.constAct.mu = loc(6);
arg.constAct.alpha = loc(7);
arg.constAct.eta = loc(8);
arg.constAct.beta = loc(9);
arg.constAct.gamma = loc(10);

arg.constBoost.temp = loc(11);
arg.constBoost.k = loc(12);
arg.constBoost.mu = loc(13);
arg.constBoost.alpha = loc(14);
arg.constBoost.eta = loc(15);
arg.constBoost.beta = loc(16);
arg.constBoost.gamma = loc(17);

arg.par.RT.proficiency = loc(18);
arg.par.RT.add = loc(19);

end

