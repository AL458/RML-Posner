function [congruence,RT] = load_RT(filename)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
load(filename);

congruence = [];
RT = [];
se=[];
counter = 1;
for trialnr = 1:length(data.textdata)
    currtype = data.textdata{trialnr};
    if not(strcmp(currtype,'Catch')) % Remove all catch trials
        if not(isnan(data.data(trialnr)))
            switch currtype
                case 'Valid'
                    congruence(counter)=1;
                case 'Invalid'
                    congruence(counter)=-1;
                case 'Neutral'
                    congruence(counter)=0;
            end
            RT(counter)=data.data(trialnr);
            if trialnr<=length(data.textdata)/2
                se(counter)=2;
            else
                se(counter)=3;
            end
            counter = counter+1;
            
        end
    end
end
RT = RT';
congruence = congruence';

end

