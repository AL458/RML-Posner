function [param, MMSE_array_fin, loc_array_fin,boostarray] = test_output_redo_MMSE(param,locarray,MMSE_array,nreps);
% Reruns the MMSE estimation for ALL locations found
nruns = param.current.iteration+1;
temp = [];
% For each of the visited locations, recalculate the MMSE with more trials
for locind = 1:nruns
    loc_curr = locarray(:,locind);
    [MMSE_curr,boostarray{locind},RT_curr,struct_curr] = Get_MMSE(loc_curr,nreps,param);
    % Save current location and LL    
    param.history.test.loc_array_fin(1:length(loc_curr),locind) = loc_curr;
    param.history.test.MMSE_array_fin(locind) = MMSE_curr;
    param.history.test.RT_array(1:length(RT_curr),locind) = RT_curr;
    param.history.test.other_array{locind}=struct_curr;
end
param.history.test.boostarray = boostarray;
% Find the location with the most optimal MMSE given the larger amount of
% trials. This is the location that best fits the participant data
optind = find(param.history.test.MMSE_array_fin == min(param.history.test.MMSE_array_fin));
param.history.test.optind = optind;
MMSE_array_fin = param.history.test.MMSE_array_fin;
loc_array_fin = param.history.test.loc_array_fin;


end

