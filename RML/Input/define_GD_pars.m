function param = define_GD_pars(processn)
%Generates the structure param, for use in the optimization algorithms.
%!!! IMPORTANT!!! Please note, only change this function, do NOT change
%other functions in this package!
% Load in the relevant RML optimization parameters
load(fullfile('Input','GD_param.mat'),'param');
% Load in the relevant RML parameters
load(fullfile('Input','model_parameters.mat'),'arg');
param.initarg = arg;
%% Other parameters
% Define the output path for the current run
param.current.outpath = strcat('Output/Temp/Gradient_Desc_part_',num2str(processn),'.mat'); % Path where output is stored

end

