%% Copyright 2014 MERCIER David
function deltaH = hardness_incertitude(Load, Disp, Stif, Disp_c, H,...
    deltaLoad, deltaDisp, deltaStif)
%% Function used to calculate hardness incertitude

deltaDisp_c = Disp_c.*(deltaDisp./Disp + deltaLoad./Load + deltaStif./Stif);

deltaH = H.*(deltaLoad./Load + 2*(deltaDisp_c./Disp_c));

end