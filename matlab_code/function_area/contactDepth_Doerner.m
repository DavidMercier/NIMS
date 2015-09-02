%% Copyright 2014 MERCIER David
function hc = contactDepth_Doerner(h, h_tip, P, S, varargin)
%% Function used to calculate the contact depth from
% Doerner et al. (1986) - http://dx.doi.org/10.1557/JMR.1986.0601

% hc: Contact depth in nm

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

hc = (h + h_tip) - (P./S);

end