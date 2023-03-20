function [param, stop,MMSE_next] = test_stopping_MMSE(param,loc,MMSE,loc_next,MMSE_next)
% Decides whether to stop, or continue with the next iteration. In this
% simulation, the only stopping criteria is after the number of iterations
% is equal to the maximum number of iterations

% Check for improvements
if sqrt(sum((loc-loc_next).^2))<param.stopping.delta
    %Locations are too close to each other
    param.current.no_dist_imp = param.current.no_dist_imp + 1;
else
    param.current.no_dist_imp = 0;
end

if (MMSE-MMSE_next)<param.stopping.logdelta
    %LL does not improve
    param.current.no_LL_imp = param.current.no_LL_imp + 1;
else
    param.current.no_LL_imp = 0;
end

% Test if LL is below stopping epsilon

if abs(MMSE_next)<param.stopping.epsilon
    param.current.no_epsilon = param.current.no_epsilon + 1;
else
    param.current.no_epsilon = 0;
end

% Test number of iterations
if param.current.iteration >= param.stopping.maxiterations
    stop = 1;
elseif param.current.no_LL_imp >= param.stopping.logtimes
    stop = 1;
elseif param.current.no_dist_imp >= param.stopping.maxiterations
    stop = 1;
elseif param.current.no_epsilon >= param.stopping.epstimes
    stop = 1;
else
    stop = 0;
end

% Additionally, stop if the LL_next = 0: this happens most likely due to a
% rounding error
if MMSE_next == 0
    stop = 1;
    MMSE_next = -10;
end

%% Add loc and LL to param
iteration = param.current.iteration;
param.arrays.loc(1:length(loc),iteration) = loc;
param.arrays.locnext(1:length(loc),iteration) = loc_next;
param.arrays.MMSE(iteration) = MMSE;
param.arrays.MMSE_next(iteration) = MMSE_next;

end

