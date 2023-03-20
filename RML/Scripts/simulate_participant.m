function sbehav = simulate_participant(loc,par)
%Simulates one participant based on loc: the HT, DA and NE parameter

%restoredefaultpath
rng('shuffle');%rand initialization of random generator

nruns = size(par.tasks.envs,2)*par.tasks.blocklength;
arg=param_build_effort(loc,nruns,par,par.tasks.trainenv);
% Perform training

sbehav=kenntask_sim(arg);
%second_level_an_eff(arg,sbehav)

end