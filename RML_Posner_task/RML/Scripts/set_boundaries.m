function curr_loc = set_boundaries(curr_loc,param)
optover = param.optover;
try load(fullfile('Input','parameter_limits.mat'))
    for i = 1:19
        if optover(i)
            if curr_loc(i)<parameter_limits(1,i)
                curr_loc(i)=parameter_limits(1,i);
            end
            if curr_loc(i)>parameter_limits(2,i)
                curr_loc(i)=parameter_limits(2,i);                
            end
        end
    end
end

%Sets minimal and maximal values for all values in loc
if curr_loc(3)<param.grad.NE_cutoff % Make sure that NE is non-negative
    curr_loc(3) = param.grad.NE_cutoff;
end
% loc(4), the action temperature should be higher than 0.1
if curr_loc(4)<0.1
    curr_loc(4) = 0.1;
end
% The same holds for the boost temperature
if curr_loc(11)<0.1
    curr_loc(11) = 0.1;
end


% the initial kalman gain in the action module (5) and boost module (12)

if curr_loc(5)<0
    curr_loc(5)=0;
elseif curr_loc(5)>1
    curr_loc(5)=1;
end
if curr_loc(12)<0
    curr_loc(12)=0;
elseif curr_loc(12)>1
    curr_loc(12)=1;
end
    
% The learning parameter alpha should not be higher than 0.4, or lower than
% 0.0005
alphamax = 1;
alphamin = 0.00005;
if curr_loc(7)<alphamin
    curr_loc(7)=alphamin;
elseif curr_loc(7)>alphamax
    curr_loc(7)=alphamax;
end
if curr_loc(14)<alphamin
    curr_loc(14)=alphamin;
elseif curr_loc(14)>alphamax
    curr_loc(14)=alphamax;
end
% Eta needs to be strictly lower than 1
etamax = 0.95;
if curr_loc(8)>etamax
    curr_loc(8)=etamax;
end
if curr_loc(15)>etamax
    curr_loc(15)=etamax;
end

% Mu is between 0 and 1:
mumin = 0;
mumax = 0.95;
if curr_loc(6)<mumin
    curr_loc(6)=mumin;
elseif curr_loc(6)>mumax
    curr_loc(6)=mumax;
end
if curr_loc(13)<mumin
    curr_loc(13)=mumin;
elseif curr_loc(13)>mumax
    curr_loc(13)=mumax;
end

% Proficiency should be at least 0
if curr_loc(18)<0
    curr_loc(18)=0;
end


end

