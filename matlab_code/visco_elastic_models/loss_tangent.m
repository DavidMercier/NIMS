%% Copyright 2014 MERCIER David
function lossTangent = ...
    loss_tangent(harmonicDamping, stiffness, varargin)
%% Function used for the calculation of the loss tangent from dynamic nanoindentation
% harmonicDamping : Harmonic contact damping in (N.s)/nm
% stiffness : Contact stiffness in mN/nm
% loss_tangent: The loss tangent

if nargin == 0
    harmonicDamping = 0.001;
    stiffness = 1.32;
end

lossTangent = harmonicDamping / stiffness;

end