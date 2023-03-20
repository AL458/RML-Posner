function [loc,optover,MMSE] = set_first_loc_MMSE(param,estimated_parameters)
%Defines the first location for starting the grid search
% Runs get_ll on the first location

l_needed = param.grad.vars;
reps = param.grad.reps;

% Get initial location and which variables to optimize over
[loc,optover] = get_module_values(param,estimated_parameters);
param.optover = optover;
% Generate the log likelihood for loc
[MMSE,~] = Get_MMSE(loc,reps,param);
%LL.value = mean(LL_arr);
%LL.var = std(LL_arr);
%LL.tries = reps;

end

