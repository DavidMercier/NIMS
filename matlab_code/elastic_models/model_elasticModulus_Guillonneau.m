%% Copyright 2014 MERCIER David
function [Eeff_red, Esample_red, Esample] = model_elasticModulus_Guillonneau(...
    model, load, stiffness, slopeDepth, theta, m, nu_sample, gcfValue, alpha, varargin)
%% Function used to calculate the elastic modulus using derivative of the contact depth from
% Guillonneau G. et al. (2014) - http://dx.doi.org/10.1016/j.triboint.2013.10.013

% author: david.mercier@crmgroup.be

% model: Variable to sel type of model : (Loubet = 1 / Oliver and Pharr = 2)
% load: Applied load in mN
% stiffness: Stiffness in mN/nm
% slopeDepth: Slope of the linear fit of hc=f(h).
% theta: Half-angle of the indenter in degrees
% m : Exponent describing the shape of the unloading curve

if nargin < 9
    alpha = 1.2;
end

if nargin < 8
    gcfValue = gcf;
end

if nargin < 7
    nu_sample = 0.3;
end

if nargin < 6
    m = 1.5;
end

if nargin < 5
    theta = 70.32;
end

if nargin < 4
    slopeDepth = 1;
end

if nargin < 3
    stiffness = 1;
end

if nargin < 2
    load = 1;
end

if nargin < 1
    model = 1;
end

if model == 1
    Eeff_red = 1e6.*(((stiffness.^2) ./ (2.*load.*tand(str2num(theta)))) .* ((1/(slopeDepth))-(1)));
elseif model == 2
    epsilon = epsilon_oliver_pharr(m); 
    Eeff_red = 1e6.*(((stiffness.^2) ./ (2.*epsilon.*load.*tand(str2num(theta)))) .* ((1/(slopeDepth))-1));
elseif model == 3
    alpha = 1.2;
    Eeff_red = 1e6.*(((stiffness.^2) ./ (2.*load.*tand(str2num(theta)))) .* ((1/(slopeDepth))-(1/alpha)));
end

% Indenter's properties
[Eind, nuind, Eind_red] = indenter_properties(gcfValue);

% Reduced Young's modulus of the sample in GPa (no indenter's contribution)
Esample_red = ((1./Eeff_red) - (1/(1e-9*Eind_red))).^(-1);

% Young's modulus of the sample in GPa
Esample = non_reduced_YM(Esample_red, nu_sample); 

end