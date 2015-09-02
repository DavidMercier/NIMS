%% Copyright 2014 MERCIER David
function hc = contactDepth_Loubet(h, h_tip, P, S, aLoubet, varargin)
%% Function used to calculate the contact depth from
% Hochstetter et al. (1998) - http://dx.doi.org/10.1080/00222349908248131

% hc: Contact depth in nm

if nargin < 5
    aLoubet = 1.2;
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
    
hc = aLoubet .* (h + h_tip - (P./S));

end