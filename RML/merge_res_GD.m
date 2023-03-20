function merge_res_GD(nprocs)
% Merges the results for the GD processes, for nprocs processes, in case
% more than one process is used. Then stores the results in a format that
% can be read in by the analysis function as results_GD

addpath('Input')

subj = 1;
results_GD = [];
results_GD.param = {};
results_GD.boost = {};

for counter = 1:nprocs
    param = define_GD_pars(counter);
    outpath = param.current.outpath;
    current = load(outpath);
    current = current.subj_out;
    for i = 1:length(current.DA)
        results_GD.MMSE_opt(subj) = current.LL_opt(i);
        results_GD.opt_var(subj) = current.opt_var(i);
        results_GD.time(subj) = current.time(i);
        results_GD.boost{subj} = current.boost{i};
        % Copy only useful stuff from param, to save space
        curr_par = current.param{i};
        to_add = [];
        to_add.settings = curr_par;
        to_add.settings.current.sbehavdata = [];
        to_add.settings.history = [];
        to_add.settings.arrays = [];
        to_add.settings.testout = [];        
        to_add.history = curr_par.arrays;
        to_add.history.final_output = curr_par.testout;
        to_add.history.details = curr_par.history;
        to_add.history.details.test = [];
        
        % Add output
        output = curr_par.history.test;
        to_add.output.optimal_iteration = output.optind;
        to_add.output.location = output.loc_array_fin(:,output.optind);
        to_add.output.MMSE = output.MMSE_array_fin(output.optind);
        to_add.output.boost = output.boostarray{output.optind};
        to_add.output.RT = output.RT_array(:,output.optind);

        details = output.other_array{output.optind};
        to_add.output.average_values = details.average_values;
        to_add.output.k_cues = details.k_act_cues;
        to_add.output.k_neutral = details.k_act_neut;
        to_add.output.average_responses = details.avgresp;
        % Add more detailed information
        to_add.output.details.sd_average_values = details.sd_avg_values;
        to_add.output.details.k_boost_cues = details.k_boost_cues;
        to_add.output.details.k_boost_neutral = details.k_boost_neut;
        to_add.output.details.responses_output = details.responses_raw;
        to_add.output.details.k_action_output = details.k_act_raw;
        to_add.output.details.k_boost_output = details.k_boost_raw;
        results_GD.param{subj} = to_add;

        
        subj = subj+1;
    end
end
subj_out = results_GD;
save(fullfile('Output','results_GD.mat'),'subj_out');
rmpath('Input')

end

