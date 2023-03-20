%write down RML and environmental parameters data structure

function arg=param_build_effort(loc,nrun,par,envnr)
load(fullfile('Input','model_parameters.mat'),'arg');
arg.par = par;
arg.nrun=nrun;
arg.nsubj=1;
arg.initstate=par.init.state;%1=3rd order, 2=2nd order, 3=1st order.
arg.nexcltri=par.analyse.trialstoskip;%trials to esclude for data analysis
arg.nactions=par.tasks.nact;%numb of possible actions by dACC_Action
arg.nactions_boost=par.tasks.nboost;%numb of possible actions by dACC_Boost

%select monoamine levels
arg.constAct.DAlesion=par.init.DA;%default=1 (no lesion)
arg.constAct.NElesion=par.init.NE;%default=1 (no lesion)
arg.constAct.HTlesion=par.init.HT;%default=.15 (no lesion)

%arg.volnum=[14,22];%min and max trials before a change point in volatility task (SE=3)

%reward mean magnitude and variance by SE
currenv = par.tasks.env{envnr};
arg.RWM=currenv.RWM;
arg.var=currenv.rwvar;
arg.trans = currenv.trans;
arg.RWP=currenv.RWP;
arg.cost=currenv.cost;
 
%number of statistical environments administered. Sets the number of trials
%that are not in training blocks.
arg.SEN=par.tasks.envs;%SE*REPS;each SE is 90 trials (e.g. [1 1 1] = 270 trials)
arg.ntrial=par.tasks.blocklength*length(arg.SEN(arg.SEN>0));
%arg.chance=0.5;%specify what is the a priori chance level to execute the task optimally (it can refer either to the entire trial or to single steps)
%arg.chance2=0.5;%specify what is the a priori chance level to execute the task optimally 
%(if prob is referred to completing the task, then 0, otherwise it refers to the prob of answering correclty to each state within a trial)

%% Load in model parameters

arg.constAct.costs=arg.cost;
arg.constAct.nstate=par.tasks.nstates;

%arg.constAct.classic=0;%if 0=instrumental task, if 1= pavlovian

%prior costs matrix for motor actions

arg.constBoost.omega=arg.constAct.HTlesion;%BOOST COST!
arg.constBoost.DAlesion=par.init.DA;%default=1 (no lesion)
arg.constBoost.NElesion=par.init.NE;%default=1 (no lesion)
arg.constBoost.HTlesion=par.init.HT;%default=.15 (no lesion)
arg.constBoost.costs=zeros(arg.constAct.nstate,arg.nactions_boost);

% Get parameters from the current location in the optimization process in
% parameter space 
arg = unpack_loc(loc,arg);

%init value weights
if strcmp(par.init.W3,'known')
    arg.W3 = arg.RWM;
elseif sum(size(par.init.W3)== [arg.constAct.nstate arg.nactions])==2
    arg.W3 = par.init.W3;
else
    arg.W3=zeros(arg.constAct.nstate,arg.nactions);
end

if strcmp(par.init.We3,'known')
    arg.We3=repmat(1-arg.constBoost.omega*[1:arg.nactions_boost],max(arg.trans(:))-1,1);
elseif sum(size(par.init.We3)== [arg.constAct.nstate arg.nactions_boost])==2
    arg.We3 = par.init.We3;
else
    arg.We3 = zeros(arg.constAct.nstate,arg.nactions_boost);
end

% save W3 W3
% save We3 We3
% 
% save arg arg