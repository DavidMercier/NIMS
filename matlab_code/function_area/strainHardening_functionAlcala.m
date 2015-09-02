%% Copyright 2014 MERCIER David
function fn = strainHardening_functionAlcala(n, varargin)
%% Function used to calculate the strain hardening function from
% Alcala et al. (2000) - http://dx.doi.org/10.1016/S1359-6454(00)00140-3

% fn: Strain hardening function

if nargin < 1
    n = 0.2; % Strain-hardening coefficient
end

fn = 1.202 - 0.857 * n + 0.302*n^2;

end