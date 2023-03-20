% This script is written for the reproduction of the results from the RML
% analysis in this study. It runs each of the three necessary steps in
% order in order to arrive at the final output used to generate the figures
% in the main text.


%% Get the Kalman gain from the output
cd('Get_Kalman_gain')
Get_Kalman_gain(fullfile('..','RML','Output','results_GD.mat'))
cd('..')

% After running the script, a file called kalman_gain_simulation is
% generated in this folder, containing the average estimated LR timecourse
% for each participant in a separate cell. 