function [loc_next, MMSE_next, param] = optimize_gradient_parfit_MMSE(param,loc,~)
% Optimizes the gradient using line search.
% Input parameter LL is not used
data_points = param.linear.points;
grad = param.current.grad;
factors = linspace(param.linear.mindist,param.linear.maxdist,data_points);
loc_array = zeros(19,size(factors,2));
MMSE_array = zeros(data_points,1);
reps = param.grad.reps;
for counter = 1:data_points
    % Get parameter values
    curr_loc = loc+grad*factors(counter);
    curr_loc = set_boundaries(curr_loc,param);
    loc_array(:,counter) = curr_loc;
    [curr_MMSE,b,RT_est] = Get_MMSE(curr_loc,reps,param);
    MMSE_array(counter) = curr_MMSE;
end
% Take theoretically best location, given that the output space of the
% optimization problem is locally approximated by a parabola around the
% optimal value, and test the MMSE for this location  
optloc = fitparabola_MMSE(factors,MMSE_array');
addloc = optloc*grad;
addloc(addloc>param.grad.max) = 10;
addloc(addloc<-param.grad.max) = -10;
curr_loc = loc+addloc;
curr_loc = set_boundaries(curr_loc,param);
loc_array(:,counter+1) = curr_loc;
curr_MMSE = Get_MMSE(curr_loc,reps,param);
MMSE_array(counter+1) = curr_MMSE;
% Test which location was best in estimating the RT by taking the location
% which had the most optimal MMSE
min_ind = find(MMSE_array==min(MMSE_array));
% if more than one maximum index, set the maximum index to a random one
if length(min_ind)>1
    min_ind = min_ind(randperm(length(min_ind),1));
end
    
loc_next = loc_array(:,min_ind)';
MMSE_next = MMSE_array(min_ind);

iteration = param.current.iteration;
% Store history
param.history.locarray{iteration} = loc_array;
param.history.MMSEarray{iteration} = MMSE_array;
param.history.loc_next(1:length(loc_next),iteration) = loc_next';
param.history.MMSE_next(iteration) = MMSE_next;
end

