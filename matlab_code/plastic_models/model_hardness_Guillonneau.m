%% Copyright 2014 MERCIER David
function hardness = model_hardness_Guillonneau(load, stiffness, red_YM, varargin)
%% Function used to calculate the hardness using derivative of the contact depth from
% Guillonneau G. et al. (2014) - http://dx.doi.org/10.1016/j.triboint.2013.10.013

% author: david.mercier@crmgroup.be

% load: Applied load in mN
% stiffness: Stiffness in mN/nm
% red_YM: Reduced elastic modulus in GPa

if nargin < 3
    red_YM = 1;
end

if nargin < 2
    stiffness = 1;
end

if nargin < 1
    load = 1;
end

hardness = 1e-6 .* (4 .* load .* (red_YM.^2)) ./ (pi * (stiffness.^2));

end