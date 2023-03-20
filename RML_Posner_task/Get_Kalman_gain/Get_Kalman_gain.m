function Get_Kalman_gain(subj_out_location)

load(subj_out_location)
counter = 1;
for i = 1:length(subj_out.param)
    kalman_gain{counter} = subj_out.param{counter}.output.k_cues;
    counter = counter+1;
end
save('Kalman_gain_simulation.mat','kalman_gain')
save(fullfile('..','Kalman_gain_simulation.mat'),'kalman_gain')