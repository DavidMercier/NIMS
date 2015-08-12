%% Copyright 2014 MERCIER David
function load = load_displacement_Malzbender(h, Esample, Hsample, ...
    nu_sample, theta_eq, m, n, varargin)
%% Function used plot the load-displacement curve using the expression proposed
% by Malzbender et al. - http://dx.doi.org/10.1557/JMR.2002.0070

% load: Indentation load in mN

if nargin < 6
    n = 0.2; % Strain-hardening coefficient
end

if nargin < 6
    m = 1.5; % Exponent describing the shape of the unloading curve
end

if nargin < 5
    theta_eq = 70.3; % Half-angle of the indenter in degrees
end

if nargin < 4
    nu_sample = 0.3; % Poisson's coefficient of the sample
end

if nargin < 3
    Hsample = 1; % Hardness of the sample in GPa
end

if nargin < 2
    Esample = 70; % Young's modulus of the sample in GPa
end

if nargin < 1
    h = 0.1; % Indentation displacement in microns
end

epsilon = epsilon_oliver_pharr(m);

beta = beta_hay(theta_eq, nu_sample);

yieldStressValue = YieldStress(Hsample, 2.8);

K = Esample / ((1/(tan(theta_eq) * pi^0.5)) * (Esample / Hsample)^0.5 + ...
    (epsilon/beta)*((pi*Hsample)/(4*Esample))^0.5)^2;

fn =  (1.28 - 0.8*n)*(1 - 14.78 * (yieldStressValue / Esample));

load = K .* (h .* fn).^2;

end