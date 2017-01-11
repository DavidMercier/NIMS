%% Copyright 2014 MERCIER David
function R_tip = tipRadius(tipDefect, coneAngle, varargin)
%% Function used to calculate the tip defect for a cono-spherical indenter

% tipDefect: Tip defect in micron
% coneAngle: Equivalent cone angle in degrees

if nargin < 2
    coneAngle = 70.32; % Equivalent cone angle in degrees
end

if nargin < 1
    tipDefect = 1; % Radius of the spherical tip in nm
end

R_tip = tipDefect / ((1/sind(coneAngle)) - 1);

end