%% Copyright 2014 MERCIER David
function phigao0 = phi_gao_0(x, nuc, varargin)
%% This weighting function I0 given by Gao et al. (1992)
% provides a smooth transition from film to substrate.

% nuc: Poisson's coefficient of the composite (film + substrate)

if nargin < 1
    x = 0:0.1:100;
    phigao1 = phi_gao_1(x);
    nus = 0.4;
    nuf = 0.2;
    nuc = composite_poissons_ratio(nus, nuf, phigao1);
    phigao0 = phi_gao_0(x, nuc);
    figure;
    plot(x, phigao0, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('x', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('\Phi _0', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    save_figure(pwd, gca, '_phi0Gao');
end

phigao0 = (2/pi).*atan(x) + ((1./(2.*pi.*(1-nuc))) .* ...
    (((1-2*nuc).*x.*log(1+(1./x).^2)) - (x./(1+(x).^2))));

end