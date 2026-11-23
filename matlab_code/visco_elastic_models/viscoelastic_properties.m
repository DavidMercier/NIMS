%% Copyright 2014 MERCIER David
function [storageModulus, lossModulus, lossTangent] = ...
    viscoelastic_properties(stiffness, contactDamping, contactArea, beta)
%% Calculate reduced viscoelastic properties from dynamic nanoindentation
% stiffness : Contact stiffness in N/m
% contactDamping : Contact damping C*omega in N/m, omega in rad/s
% contactArea : Contact area in m2
% beta : Geometrical correction factor
% storageModulus, lossModulus : Reduced moduli in GPa
% lossTangent : Dimensionless loss tangent

if nargin ~= 4
    error('NIMS:Viscoelastic:InvalidNumberInputs', ...
        'Stiffness, contact damping, contact area, and beta are required.');
end

validateattributes(stiffness, {'numeric'}, ...
    {'real', 'nonempty', 'finite', 'positive'});
validateattributes(contactDamping, {'numeric'}, ...
    {'real', 'nonempty', 'finite', 'nonnegative'});
validateattributes(contactArea, {'numeric'}, ...
    {'real', 'nonempty', 'finite', 'positive'});
validateattributes(beta, {'numeric'}, ...
    {'real', 'nonempty', 'finite', 'positive'});

inputs = {contactDamping, contactArea, beta};
for ii = 1:numel(inputs)
    if ~isscalar(inputs{ii}) && ~isequal(size(inputs{ii}), size(stiffness))
        error('NIMS:Viscoelastic:IncompatibleInputSizes', ...
            'Inputs must be scalars or have the same size as stiffness.');
    end
end

modulusFactor = 1e-9 .* sqrt(pi ./ contactArea) ./ (2 .* beta);
storageModulus = modulusFactor .* stiffness;
lossModulus = modulusFactor .* contactDamping;
lossTangent = contactDamping ./ stiffness;

end
