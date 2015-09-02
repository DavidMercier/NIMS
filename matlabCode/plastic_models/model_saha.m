%% Copyright 2014 MERCIER David
function Hf = model_saha(stiffness, load, Em_red, gcfValue)
%% Function used to calculate hardness of a thin film with Saha's method (2002)
% S: Stiffness in mN/nm
% P: Applied load during indentation test mN
% Ef_red: Reduced Young's modulus of the thin film obtained with a elastic
% bilayer or multilayer model in GPa

% Constants definition
beta_Val = beta_selection;

% Indenter properties
[Eind, nuind, Eind_red] = indenter_properties(gcfValue);

% Hardness calculation with Saha's method
Etot_red = ((1./Em_red) + (1./(Eind_red*1e-3))).^-1; %in GPa
Hf = beta_Val^2 .* (4/pi) .* (load./(10^6.*stiffness.^2)) .* Etot_red.^2;

end