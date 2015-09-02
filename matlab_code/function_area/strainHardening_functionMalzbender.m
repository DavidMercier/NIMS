%% Copyright 2014 MERCIER David
function fn = strainHardening_functionMalzbender(Esample, Hsample, n, varargin)
%% Function used to calculate the strain hardening function from
% Malzbender et al. (2002) - http://dx.doi.org/10.1557/JMR.2002.0070

% fn: Strain hardening function

if nargin < 3
    n = 0.2; % Strain-hardening coefficient
end

if nargin < 2
    Hsample = 1; % Hardness of the sample in GPa
end

if nargin < 1
    Esample = 70; % Young's modulus of the sample in GPa
end

yieldStressValue = YieldStress(Hsample, 2.8);

fn = (1.28 - 0.8*n)*(1 - 14.78 * (yieldStressValue / Esample));

end