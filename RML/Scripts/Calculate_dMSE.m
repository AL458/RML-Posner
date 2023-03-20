function d_mse = Calculate_dMSE(R_1,R_2)
% Calculates the MMSE from two response matrices. Excludes any missing
% trials in sbehav
missing = zeros(length(R_1),1);
R_1_missing = R_1==0|isnan(R_1);
R_2_missing = R_2==0|isnan(R_2);
if(sum(R_1_missing)>0)
    missing = missing+R_1_missing;
end
if(sum(R_1_missing)>0)
    missing = missing+R_2_missing;
end
missing(missing==2)=1;
R_1 = R_1(~missing);
R_2 = R_2(~missing);
    
d_mse = sum((log(R_1.^-1)-log(R_2.^-1)).^2);

end

