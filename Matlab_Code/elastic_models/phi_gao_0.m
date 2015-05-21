%% Copyright 2014 MERCIER David
function phigao0 = phi_gao_0(x, nuc)
%% This weighting function I0 given by Gao et al. (1992)
% provides a smooth transition from film to substrate.

% nuc: Poisson's coefficient of the composite (film + substrate)

phigao0 = (2/pi).*atan(x) + ((1./(2.*pi.*(1-nuc))) .* ...
    (((1-2*nuc).*x.*log(1+(1./x).^2)) - (x./(1+(x).^2))));

end