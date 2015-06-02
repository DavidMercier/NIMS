%% Copyright 2014 MERCIER David
function K = unload_k_m(m, varargin)
%% Function used for the calculation of the constant K used to described
% unloading curve knowing the coefficient m described by Pharr and
% Bolshakov (2002)

if nargin < 1
    m = 1:0.02:2;
    K = unloadCoeff(m);
    figure;
    plot(m, K, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('m', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('K', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    save_figure(pwd, gca, '_K(m)');
end

K = (2./(m.*pi.^0.5)).^m;

end