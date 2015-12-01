%% Copyright 2014 MERCIER David
function deltaE = elasticModulus_incertitude(Load, Disp, Stif, Disp_c, E,...
    deltaLoad, deltaDisp, deltaStif)
%% Function used to calculate elastic modulus incertitude

deltaDisp_c = Disp_c.*(deltaDisp./Disp + deltaLoad./Load + deltaStif./Stif);

deltaE = E.*(deltaStif./Stif - 2*(deltaDisp_c./Disp_c));

end