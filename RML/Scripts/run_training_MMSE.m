function [par,loc] = run_training_MMSE(par,param,loc)
% Function for running the model training. This sets the prior value of the
% expected value matrix given the current parameter location
ntrainreps = param.estimate.trainruns;
ntrainenvs = param.initarg.par.tasks.blocklength*sum(param.initarg.par.tasks.envs==1);
ntraintrials = param.estimate.traintrials+ntrainenvs;
trainout_act = cell(ntrainreps,1);
trainout_boost = cell(ntrainreps,1);
k_train = zeros(par.tasks.nstates,ntrainreps);
k2_train = zeros(par.tasks.nstates,ntrainreps);
V_train = zeros(ntrainreps,par.tasks.nstates,par.tasks.nact);
V2_train = zeros(ntrainreps,par.tasks.nstates,par.tasks.nboost);

for trainnumber = 1:ntrainreps
    % runs the training once, and store the results
    % Initialize parameters
    rng('shuffle');%rand initialization of random generator
    arg=param_build_effort(loc,ntraintrials,par,par.tasks.trainenv);
    % Perform training
    sbehav=kenntask_train(arg);
    % Set action value, boost value, kalman gain action and kalman gain
    % boost
    k_train(:,trainnumber) = sbehav.k(:,end);
    k2_train(:,trainnumber) = sbehav.k2(:,end);
    V_train(trainnumber,:,:) = sbehav.V(:,end,:);
    V2_train(trainnumber,:,:) = sbehav.V2(:,end,:);
end
% Average training output
mean_k = mean(k_train,2);
mean_k2 = mean(k2_train,2);
mean_V = squeeze(mean(V_train,1));
mean_V2 = squeeze(mean(V2_train,1));

% Set initial kalman gains and initial V,V2 equal to the found mean values
par.init.W3 = mean_V;
par.init.We3 = mean_V2;
loc(5) = mean_k(1);
loc(12) = mean_k2(1);

end

