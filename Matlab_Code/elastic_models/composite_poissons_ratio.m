%% Copyright 2014 MERCIER David
function nuc = composite_poissons_ratio(nus, nuf, phigao1)
%% This function gives a simple expression of the single apparent
% Poisson's ratio of the composite (film + substrate), which is function of
% the Poisson's ratio of the film, the Poisson's ratio of the substrate, 
% and I1 the weighting function given by Gao et al. (1992)

% nus : Poisson's ratio of the substrate
% nuf : Poisson's ratio of the film

nuc = 1-(((1-nus)*(1-nuf)) ./ (1-(1-phigao1)*nuf-(phigao1*nus)));

end