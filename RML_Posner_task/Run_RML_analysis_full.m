% This script is written for the reproduction of the results from the RML
% analysis in this study. It runs each of the three necessary steps in
% order in order to arrive at the final output used to generate the figures
% in the main text.

%% Conversion of the participant data to the datastructure of the RML
cd(fullfile('Generate_sbehav','Generate_sbehav_from_file'))
convert_participant_folder(fullfile('..','Subjects'));

cd(fullfile('..','..'))

%% Run RML on the sbehav data
cd('RML')
main_GD_MMSE(1,1,151) % runs the RML using one process, for all 151 participants. The original script was run using 8 different processes. This can be replicated by 
merge_res_GD(1) % Converts the RML generated using one process
cd('..')

%% Get the Kalman gain from the output
cd('Get_Kalman_gain')
Get_Kalman_gain(fullfile('..','RML','Output','results_GD.mat'))
cd('..')

% After running the script, a file called kalman_gain_simulation is
% generated in this folder, containing the average estimated LR timecourse
% for each participant in a separate cell. 