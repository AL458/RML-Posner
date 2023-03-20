function [MMSE,b,RT_est,struct] = Get_MMSE(loc,reps,param)
%GET_MMSE Calculates the MMSE from a true distribution and an input
%location (parameters for HT, DA, and NE).
% Input: loc: the location parameters (HT, DA, and NE)
% par_GS: the grid search parameters
% reps: the amount of repetitions
% R_T: the true response matrix
% Outputs the MMSE and boost variable
HT = loc(1);
DA = loc(2);
NE = max(loc(3),param.grad.NE_cutoff);
RT_true = param.current.RT_true;
par = define_vars(loc);
par.state = par.state_train;
par.init.state = par.init.state_train;
% The following part is only used in the original version of the RML
try
    if size(par.list_train,2)>1 % Multiple participants have different lists
        par.list = par.list_train{param.current.subj};
    else
        par.list = par.list_train{1};
    end
catch
    %error('No list found!')
end
% Simulate participant data
nact = par.tasks.nact;
nstate = par.tasks.nstates;
envs = unique(par.tasks.envs);
trainenvs = 1==envs;
if sum(1 == envs)
    envs(trainenvs) = [];
    % Ignore training environment
end
% run training
[par,loc] = run_training_MMSE(par,param,loc);
envs = envs-1; % Subtract one from all environments so that the environments are numbered in order
nenvs = size(envs,2);
ntrials = par.tasks.blocklength*size(par.tasks.envs,2);
% Initialize the output variables to zeros
R = zeros(ntrials,reps);
b = zeros(nstate,ntrials,reps);
k_act = zeros(nstate,ntrials,reps);
k_boost = zeros(nstate,ntrials,reps);
V_act = zeros(nstate,ntrials,nact,reps);
resp = zeros(nstate,ntrials,reps);
par.trialtypes = param.current.trialtypes;
par.sbehavdata = param.current.sbehavdata;
for rep = 1:reps
    % Simulate data from a single participant
    sbehav = simulate_participant(loc,par);
    b(:,:,rep) = sbehav.b;
    R(:,rep) = sum(sbehav.RT,1);
    k_act(:,:,rep)=sbehav.k;
    k_boost(:,:,rep)=sbehav.k2;
    V_act(:,:,:,rep)=sbehav.V;
    resp(:,:,rep)=sbehav.respside;
end
% Generate average R_e and boost
RT_est = mean(R,2);
b = mean(b,3);
struct = [];
struct.sd_avg_values = std(V_act,0,4);
struct.average_values = mean(V_act,4);
struct.responses_raw = resp;
resp = squeeze(mean(max(resp),3));
struct.k_act_raw = k_act;
struct.k_boost_raw = k_boost;
k_act = squeeze(mean(max(k_act),3));
k_boost = squeeze(mean(max(k_boost),3));
if size(b,1)~=1
    b = sum(b,1);
end
struct.avgresp = resp;
struct.k_act_cues = k_act(sbehav.ttype==1);
struct.k_boost_cues = k_boost(sbehav.ttype==1);
struct.k_act_neut = k_act(sbehav.ttype==2);
struct.k_boost_neut = k_boost(sbehav.ttype==2);
% Calculate dMSE, the mean difference between the true RT and the RT
% estimated given the input location provided. This value is optimized over
% by the gradient descent algorithm
MMSE = Calculate_dMSE(RT_true,RT_est);

end

