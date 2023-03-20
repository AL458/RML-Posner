function optloc = fitparabola_MMSE(xarray,values)
% Fits points (x,y) on a line to a parabola, and returns the maximum
% location
pol = polyfit(xarray,values,2);
if pol(1) <= 0 
    % There is no maximum, output the highest value in values as location
    optloc = xarray(values==min(values));
else
% maximum for parabola is at x = -b/2a
    optloc = -pol(2)/(2*pol(1));
end
if length(optloc)>1
    optloc = optloc(randsample(length(optloc),1));
end    
end

