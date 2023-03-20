function grad = get_gradient_MMSE(param,loc,MMSE,optover)
% Gets the gradient for the current location in parameter space
% Output: Grad.param gives an array including HT, DA, and NE
% grad.size is the total size of the gradient

R_T = param.current.RT_true;
sides = param.grad.sides;
epsilon = param.grad.epsilon;
epsilon2 = param.grad.epsilon/2;
reps = param.grad.reps;
grad = [];
grad.MMSE = zeros(length(loc),2);
NE_cutoff = param.grad.NE_cutoff;

% Make sure that all values stay in their defined ranges
logeps = epsilon*optover;
loc = set_boundaries(loc+logeps,param)-logeps;
loc = set_boundaries(loc-logeps,param)+logeps;

%if vars < 3
%    grad.param(1:(3-vars)) = loc(1:(3-vars));
%end

for gradloc = 1:19
    if optover(gradloc)
        loc_up_curr = loc;
        loc_up_curr(gradloc) = loc_up_curr(gradloc)+epsilon;
        loc_pos = Get_MMSE(loc_up_curr,reps,param);
        if sides == 2
            loc_up_curr = loc;
            loc_up_curr(gradloc) = loc_up_curr(gradloc)-epsilon;
            loc_neg = Get_MMSE(loc_up_curr,reps,param);
        else
            loc_neg = MMSE;
        end
        grad.MMSE(gradloc,1) = loc_pos;
        grad.MMSE(gradloc,2) = loc_neg;
        currgrad = (loc_pos-loc_neg)/(2*epsilon);
        if sides == 1
            grad.param(gradloc) = -currgrad*2;
        else
            grad.param(gradloc) = -currgrad;
        end        
    else
        grad.param(gradloc) = 0;
    end
end

grad.size = sqrt(sum(grad.param.^2));

end

