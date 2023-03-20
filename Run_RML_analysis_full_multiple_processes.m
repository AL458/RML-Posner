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