%% Copyright 2014 MERCIER David
function L_Jung = sigmoidal_jung(x, A_Jung, B_Jung, varargin)
%% Sigmoidal function used by Jung et al. (2004)
% to satisfy the boundary conditions of his model.

% A_Jung and B_Jung are adjustable coefficients

if nargin < 2
    % Values from Jung et al. (2004)
    % for Young's modulus
    A_Jung = 3.76;
    B_Jung = 1.38;
    % for hardness
    %A_Jung = 1.47;
    %B_Jung = 1.71;
end

if nargin < 1
    x = 0:0.1:100;
    L_Jung = sigmoidal_jung(x, A_Jung, B_Jung);
    figure;
    plot(x, L_Jung, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('x', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('L', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    save_figure(pwd, gca, '_sigmoidalYung');
end

x = checkValues(x);

L_Jung = (1./(1+A_Jung.*x.^B_Jung));

end