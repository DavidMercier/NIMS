%% Copyright 2014 MERCIER David
function phigao1 = phi_gao_1(x, varargin)
%% This weighting function I1 given by Gao et al. (1992)
% provides a smooth transition from film to substrate.

if nargin < 1
    x = 0:0.1:100;
    phigao1 = phi_gao_1(x);
    figure;
    plot(x, phigao1, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('x', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('\Phi _1', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    save_figure(pwd, gca, '_phi1Gao');
end

x = checkValues(x);

phigao1 = (2/pi).*atan(x)+(x./pi).*log((1+(x).^2)./(x).^2);

end