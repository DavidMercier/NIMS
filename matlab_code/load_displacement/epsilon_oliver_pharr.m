%% Copyright 2014 MERCIER David
function [epsilon, m] = epsilon_oliver_pharr(m, varargin)
%% Function used to plot epsilon parameter in function of m coefficient
% of unloading curves.
% See Pharr G. M.  and Bolshakov A. (2002)- DOI: 10.1557/JMR.2002.0386
% gamma function : http://de.mathworks.com/help/matlab/ref/gamma.html

% m : Exponent describing the shape of the unloading curve
% n : Exponent describing the effective indenter shape in
% m = 1 + 1/n;

if nargin < 1
    figure('Name', 'epsilon = f(m)',...
        'NumberTitle', 'off');
    
    m = (1:0.0001:2)';
    [epsilon, m] = epsilon_oliver_pharr(m);
    
    plot(m, epsilon, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    
    xlabel('m', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('\epsilon', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    
    %save_figure(pwd, gca, '_epsilonOliverPharr');
end

epsilon = m.*(1 - ((2*gamma(m./(2*(m-1))) ./ ...
    ((pi^0.5)*gamma(1./(2*(m-1))))).*(m-1)));

end