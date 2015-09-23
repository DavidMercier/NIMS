%% Copyright 2014 MERCIER David
function [Eeff_red, Esample_red, Esample] = ...
    model_elastic(stiffness, contact_area, nu_sample, gcfValue, varargin)
%% Function used for the calculation of the reduced Young's modulus
% stiffness : Contact stiffness in mN/nm
% contact_area : Contact area in nm2
% nu_sample : Poisson's ratio of the sample
% Eeff_red, Esample_red, Esample in GPa

if nargin == 0
    % Values for Si bulk sample
    stiffness = 1.32;
    contact_area = 5e7;
    nu_sample = 0.3;
    display(stiffness);
    display(contact_area);
    display(nu_sample);
    [Eeff_red, Esample_red, Esample] = ...
    model_elastic(stiffness, contact_area, nu_sample);
    display(Eeff_red);
    display(Esample_red);
    display(Esample);
    gcfValue=[];
end

%% Constants definition
beta_Val = beta_selection;

%% Indenter's properties
[Eind, nuind, Eind_red] = indenter_properties(gcfValue);

%% Young's modulus calculation - See in Pharr et al. (1992)
% Effective reduced Young's modulus (sample+indenter) in GPa
Eeff_red = ((pi^0.5)/(2*beta_Val)).* stiffness.*(1./sqrt(contact_area));

% Reduced Young's modulus of the sample in GPa (no indenter's contribution)
Esample_red = reducedValue(Eeff_red, (1e-9*Eind_red));

% Young's modulus of the sample in GPa
Esample = non_reduced_YM(Esample_red, nu_sample); 

end