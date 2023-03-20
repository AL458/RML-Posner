function [param, MMSE_opt,loc_opt,opt_boost] = test_output_MMSE(param,loc_next,MMSE_next)
% Tests the log likelihood of the output on a bigger sample

% Unpack variables
method = param.test.method;
nreps = param.test.trials;

locarray = param.arrays.loc;
locarray = [locarray loc_next'];
MMSE_array = param.arrays.MMSE;
MMSE_array = [MMSE_array MMSE_next];
% In the RML, several different methods are implemented. In these
% simulations, only the redo method is used
switch method
%    case 'final'
%        [param, MMSE_array_fin, loc_array_fin,boostarr] = test_output_final_MMSE(param,locarray,MMSE_array,nreps);
%    case 'optimal'
%        [param, MMSE_array_fin, loc_array_fin,boostarr] = test_output_optimal_MMSE(param,locarray,MMSE_array,nreps);
%    case 'optstat'
%        [param, MMSE_array_fin, loc_array_fin,boostarr] = test_output_optstat_MMSE(param,locarray,MMSE_array,nreps);
%    case 'stat'
%        [param, MMSE_array_fin, loc_array_fin,boostarr] = test_output_stat_MMSE(param,locarray,MMSE_array,nreps);
    case 'redo'
        [param, MMSE_array_fin, loc_array_fin,boostarr] = test_output_redo_MMSE(param,locarray,MMSE_array,nreps);
end
    
%% Select optimal value
optind = find(MMSE_array_fin == min(MMSE_array_fin));
if size(optind,2)>1
    optind=optind(randperm(size(optind,2),1));
end
MMSE_opt = MMSE_array_fin(optind);
loc_opt = loc_array_fin(:,optind);
opt_boost = boostarr{optind};
opt_boost(opt_boost==0) = [];
%% Store output
param.testout.ind = optind;
param.testout.MMSE = MMSE_opt;
param.testout.loc = loc_opt;
param.testout.boost = opt_boost;

end

