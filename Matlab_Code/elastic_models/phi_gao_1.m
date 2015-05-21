%% Copyright 2014 MERCIER David
function phigao1 = phi_gao_1(x)
%% This weighting function I1 given by Gao et al. (1992)
% provides a smooth transition from film to substrate.

phigao1 = (2/pi).*atan(x)+(x./pi).*log((1+(x).^2)./(x).^2);

end