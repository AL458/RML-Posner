function curr_grad = transform_curr_grad(curr_grad,param)

% Transform all gradients in their respective spaces

% Transform alpha to be between -0.4 and 0.4
curr_grad(7)=0.8/(1+exp(-1/5*curr_grad(7)))-0.4;
curr_grad(14)=0.8/(1+exp(-1/5*curr_grad(14)))-0.4;
curr_grad(curr_grad>param.grad.max)=param.grad.max;


end

