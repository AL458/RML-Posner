function [param,loc,MMSE] = update_vars_MMSE(param,loc_next,MMSE_next)
%Function for updating the location and MMSE with the newly computed
%values.
loc = loc_next;
MMSE = MMSE_next;

% Store parameter values in history
it = param.current.iteration;
param.history.epsilon(it)=param.grad.epsilon;
param.history.searchradius(it) = param.opt.size;
param.history.temp(it)=param.prob.temp;
param.history.reps(it)=param.grad.reps;


% Update parameters
param.current.iteration = param.current.iteration + 1;
param.grad.epsilon = param.grad.epsilon*param.update.epsilon;
param.opt.size = param.opt.size*param.update.searchradius;
param.prob.temp = param.prob.temp*param.update.temp;
param.grad.reps = floor(param.grad.reps*param.update.trialnum);

try param.grad.previous = param.current.grad;
catch
end
    
end

