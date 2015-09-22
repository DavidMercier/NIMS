%% Copyright 2014 MERCIER David
function hardnessCoating = model_kao_film(hardnessComposite, hardnessSubstrate, filmThickness, ...
    contactDepth, k_Kao, varargin)
%% Function used to calculate the hardness of the sample. See in Kao and Byrne (1981).
% hardnessComposite = Composite hardness of the multilayered specimen (in GPa)
% hardnessSubstrate = Hardness of the substrate (in GPa)
% filmThickness = Film thickness (in µm)
% contactDepth = Indentation contact depth (in µm)

if nargin == 0
    hardnessComposite = 100;
    hardnessSubstrate = 160;
    filmThickness = 1;
    contactDepth = 0.2;
    k_Kao = 0.09;
end

hardnessCoating = hardnessSubstrate + (contactDepth .* (hardnessComposite - hardnessSubstrate)) ...
    ./ (2 * k_Kao * filmThickness);

end