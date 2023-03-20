function [loc, optover] = get_module_values(param,estimated_parameters)
% Extracts the module values in the loc variable. Takes param (containing
% the initial variable values) and estimated_parameters (containing the
% current values for the parameters to estimate). 
% Outputs loc (the value for all parameters), and optover (the parameters
% to optimize over, as 1 (do optimize) and 0 (do not optimize).

optover = zeros(1,19);
loc = zeros(1,19);
% Check whether to optimize over NTs
if isfield(estimated_parameters,'NT')
    if isfield(estimated_parameters.NT,'HT')
        optover(1)=1;
        loc(1)=estimated_parameters.NT.HT;
    else
        loc(1)=param.firstloc(1);
    end
    if isfield(estimated_parameters.NT,'DA')
        optover(2)=1;
        loc(2)=estimated_parameters.NT.DA;
    else
        loc(2)=param.firstloc(2);
    end
    if isfield(estimated_parameters.NT,'NE')
        optover(3)=1;
        loc(3)=estimated_parameters.NT.NE;
    else
        loc(3)=param.firstloc(3);
    end
else
    loc(1:3)=param.firstloc;
end
if loc(3)<param.grad.NE_cutoff % Make sure that NE is non-negative
    loc(3) = param.grad.NE_cutoff;
end
% Check whether to optimize over ACT values
if isfield(estimated_parameters,'Act')
    if isfield(estimated_parameters.Act,'temp')
        optover(4)=1;
        loc(4)=estimated_parameters.Act.temp;
    else
        loc(4)=param.initarg.constAct.temp;
    end
    if isfield(estimated_parameters.Act,'k')
        optover(5)=1;
        loc(5)=estimated_parameters.Act.k;
    else
        loc(5)=param.initarg.constAct.k;
    end
    if isfield(estimated_parameters.Act,'mu')
        optover(6)=1;
        loc(6)=estimated_parameters.Act.mu;
    else
        loc(6)=param.initarg.constAct.mu;
    end
    if isfield(estimated_parameters.Act,'alpha')
        optover(7)=1;
        loc(7)=estimated_parameters.Act.alpha;
    else
        loc(7)=param.initarg.constAct.alpha;
    end
    if isfield(estimated_parameters.Act,'eta')
        optover(8)=1;
        loc(8)=estimated_parameters.Act.eta;
    else
        loc(8)=param.initarg.constAct.eta;
    end
    if isfield(estimated_parameters.Act,'beta')
        optover(9)=1;
        loc(9)=estimated_parameters.Act.beta;
    else
        loc(9)=param.initarg.constAct.beta;
    end
    if isfield(estimated_parameters.Act,'gamma')
        optover(10)=1;
        loc(10)=estimated_parameters.Act.gamma;
    else
        loc(10)=param.initarg.constAct.gamma;
    end
else
    loc(4:10)=[param.initarg.constAct.temp,param.initarg.constAct.k,param.initarg.constAct.mu,param.initarg.constAct.alpha,param.initarg.constAct.eta,param.initarg.constAct.beta,param.initarg.constAct.gamma];
end

% Check whether to optimize over Boost values
if isfield(estimated_parameters,'Boost')
    if isfield(estimated_parameters.Boost,'temp')
        optover(11)=1;
        loc(11)=estimated_parameters.Boost.temp;
    else
        loc(11)=param.initarg.constBoost.temp;
    end
    if isfield(estimated_parameters.Boost,'k')
        optover(12)=1;
        loc(12)=estimated_parameters.Boost.k;
    else
        loc(12)=param.initarg.constBoost.k;
    end
    if isfield(estimated_parameters.Boost,'mu')
        optover(13)=1;
        loc(13)=estimated_parameters.Boost.mu;
    else
        loc(13)=param.initarg.constBoost.mu;
    end
    if isfield(estimated_parameters.Boost,'alpha')
        optover(14)=1;
        loc(14)=estimated_parameters.Boost.alpha;
    else
        loc(14)=param.initarg.constBoost.alpha;
    end
    if isfield(estimated_parameters.Boost,'eta')
        optover(15)=1;
        loc(15)=estimated_parameters.Boost.eta;
    else
        loc(15)=param.initarg.constBoost.eta;
    end
    if isfield(estimated_parameters.Boost,'beta')
        optover(16)=1;
        loc(16)=estimated_parameters.Boost.beta;
    else
        loc(16)=param.initarg.constBoost.beta;
    end
    if isfield(estimated_parameters.Boost,'gamma')
        optover(17)=1;
        loc(17)=estimated_parameters.Boost.gamma;
    else
        loc(17)=param.initarg.constBoost.gamma;
    end
else
    loc(11:17)=[param.initarg.constBoost.temp,param.initarg.constBoost.k,param.initarg.constBoost.mu,param.initarg.constBoost.alpha,param.initarg.constBoost.eta,param.initarg.constBoost.beta,param.initarg.constBoost.gamma];
end

if isfield(estimated_parameters,'RT')
    if isfield(estimated_parameters.RT,'proficiency')
        optover(18)=1;
        loc(18)=estimated_parameters.RT.proficiency;
    else
        loc(18)=0;
    end
    if isfield(estimated_parameters.RT,'add')
        optover(19)=1;
        loc(19)=estimated_parameters.RT.add;
    else
        loc(19)=0;
    end
end

end

