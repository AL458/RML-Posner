function [loc_next,MMSE_next,param] = optimize_gradient_MMSE(param,grad,loc,MMSE)
% Optimizes the gradient, given the method given in param. requests a
% program depending on param.opt.alg, and runs the corresponding function.

mu = param.opt.mu;
grad_param = grad.param;
lambda  = param.opt.lambda;
algorithm = param.opt.alg;
% If the previous gradient exists
try
    prev_grad = param.grad.previous;
catch
    prev_grad = zeros(1,19);
end
% add the previous gradient to the current gradient
curr_grad = prev_grad*mu+lambda*grad_param;
curr_grad = transform_curr_grad(curr_grad,param);
curr_grad(curr_grad>param.grad.max)=param.grad.max;
curr_grad(curr_grad<-param.grad.max)=-param.grad.max;
param.current.grad = curr_grad;
% In the normal RML version, uses one of several optimizers. Here, only
% the parfit algorithm is used.
switch algorithm
%    case 'linear'
%        [loc_next, MMSE_next, param] = optimize_gradient_linear_MMSE(param,loc,MMSE);
    case 'parfit'
        [loc_next, MMSE_next, param] = optimize_gradient_parfit_MMSE(param,loc,MMSE);
%    case 'direct'
%        [loc_next, MMSE_next, param] = optimize_gradient_direct_MMSE(param,loc,MMSE);       
%    case 'probablistic'
%        [loc_next, MMSE_next, param] = optimize_gradient_probablistic_MMSE(param,loc,MMSE);       
%    case 'superior'
%        [loc_next, MMSE_next, param] = optimize_gradient_superior_MMSE(param,loc,MMSE);           
end
% set NE to be at least 0.1
loc_next = set_boundaries(loc_next,param);


end

