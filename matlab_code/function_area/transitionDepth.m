%% Copyright 2014 MERCIER David
function h_trans = transitionDepth(tipRadius, coneAngle, varargin)
%% Function used to calculate the transition depth (in micron) between
% the conical and the spherical parts in a cono-spherical indenter.

% tipRadius: Radius of the spherical tip in micron
% coneAngle: Equivalent cone angle in degrees

if nargin < 2
    coneAngle = 70.32; % Equivalent cone angle in degrees
end

if nargin < 1
    tipRadius = 1; % Radius of the spherical tip in micron
end

h_trans = tipRadius * (1 - sind(coneAngle));

end