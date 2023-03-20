function par = define_vars(loc)
% Load in the parameters from design_parameters.mat

% Define environment variables
load(fullfile('Input','design_parameters.mat'),'par')
par.tasks.trainenv = 1; % Which environment is considered training

HT = loc(1);
DA = loc(2);
NE = loc(3);

% Define each environment. 

% par.tasks.temp = 1;
    
%% Set analysis parameters

%par.analyse.states_to_plot = 1:8; % Which states to plot

%% Set the given HT,DA,NE
par.init.NE = NE;
par.init.DA = DA;
par.init.HT = HT;

end