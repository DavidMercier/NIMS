%% Copyright 2014 MERCIER David
function nuc = composite_poissons_ratio(nus, nuf, phigao1, varargin)
%% This function gives a simple expression of the single apparent
% Poisson's ratio of the composite (film + substrate), which is function of
% the Poisson's ratio of the film, the Poisson's ratio of the substrate, 
% and I1 the weighting function given by Gao et al. (1992)

% nus : Poisson's ratio of the substrate
% nuf : Poisson's ratio of the film

if nargin < 1
    x = 0:0.1:100;
    phigao1 = phi_gao_1(x);
    nus = 0.4;
    nuf = 0.2;
    nuc = composite_poissons_ratio(nus, nuf, phigao1);
    figure;
    plot(x, nuc, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('x', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('\nu_c', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    save_figure(pwd, gca, '_PoissonsRatioComposite');
end

nuc = 1-(((1-nus)*(1-nuf)) ./ (1-(1-phigao1)*nuf-(phigao1*nus)));

end