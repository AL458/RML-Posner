function [unit,RT,side] = get_RT(cong,Ne)%,s,arg)
% Function running the competing attractor network, with congruence cong

cong = -cong; % input 1 = congruent, 0 is neutral, -1 is incongruent

%select random stim direction
side=round(rand(1))+1;

arg.cong_effect=.001;
arg.info=.0015;
arg.ths=4;
arg.beta=0.0225;
% arg.tau=1;


unit=zeros(1,2);
RT=0;%reaction time
%noise=randn(2,1000)*.0;
count=1;

% if s<3 || (s>3 && s<6)
%    arg.info=arg.info;
% else
%    arg.info=arg.info/2;
% end

%netw input
stim=[arg.info*(Ne)-arg.cong_effect*(cong-1) arg.cong_effect*(cong-1) %left 
      arg.cong_effect*(cong-1) arg.info*(Ne)-arg.cong_effect*(cong-1)];%right

while max(unit)<arg.ths
  
    
    unit(1)=unit(1)+(stim(side,1)-arg.beta*unit(2));%*1/arg.tau;
    unit(2)=unit(2)+(stim(side,2)-arg.beta*unit(1));%*1/arg.tau;

    
    RT=RT+1;
    count=count+1;
    
    
end

%unit=unit*Ne;

end

