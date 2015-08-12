%% Copyright 2014 MERCIER David
function hc = contactDepth_OliverPharr(h, h_tip, P, S, epsilon, varargin)
%% Function used to calculate the contact depth from
% Oliver et al. (1992) - http://dx.doi.org/10.1557/JMR.1992.1564

% hc: Contact depth in nm

if nargin < 5
    epsilon = epsilon_oliver_pharr(1.5);
end

if nargin < 4
    S = 0.08; % Contact stiffness in mN/nm
end

if nargin < 3
    P = 0.2; % Load in mN
end

if nargin < 2
    h_tip = 1; % Tip defect in nm
end

if nargin < 1
    h = 100; % Total indentation depth in nm
end
    
hc = (h + h_tip) - epsilon.*(P./S);

end