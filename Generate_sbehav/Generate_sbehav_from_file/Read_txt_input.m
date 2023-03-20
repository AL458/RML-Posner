function sbehav = Read_txt_input(filename,savename)
% Reads the complete behavioral data from filename. Includes missed trials

data = readtable(filename,'Delimiter','\t','ReadVariableNames',false);

congruence = [];
RT = [];
se=[];
rw = zeros(2);
RW = zeros(2);
counter = 1;
sbehav = [];
for trialnr = 1:length(data.Var1)
    currtype = data.Var1{trialnr};
    if not(strcmp(currtype,'Catch')) % Remove all catch trials
        if 1
            switch currtype
                case 'Valid'
                    congruence(counter)=1;
                    ttype(counter)=1;
                    rw(:,counter)=[1,0];
                    RW(:,counter)=[1,0];
                case 'Invalid'
                    congruence(counter)=-1;
                    ttype(counter)=1;
                    rw(:,counter)=[0,0];
                    RW(:,counter)=[1,0];
                case 'Neutral'
                    congruence(counter)=0;
                    ttype(counter)=2;
                    rw(:,counter)=[0 1];
                    RW(:,counter)=[0 0.5];
            end
            RT(counter)=data.Var2(trialnr);
            if trialnr<=length(data.Var1)/2
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
sbehav.RT = RT;
sbehav.se = se';
sbehav.congruence = congruence;
sbehav.ttype = ttype';
sbehav.rw = rw;
sbehav.RW = RW;
try save(savename,'sbehav')
end
end

