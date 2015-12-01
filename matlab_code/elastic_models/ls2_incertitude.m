%% Copyright 2014 MERCIER David
function deltaPS2 = ls2_incertitude(Load, Stif, PS2, deltaLoad, deltaStif)
%% Function used to calculate P/S² incertitude

deltaPS2 = PS2.*(deltaLoad./Load + 2*(deltaStif./Stif));

end