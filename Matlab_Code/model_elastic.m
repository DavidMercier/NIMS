%% Copyright 2014 MERCIER David
function model_elastic
%% Function used for the calculation of the reduced Young's modulus

gui = guidata(gcf);

%% Young's modulus calculation - See in Pharr et al. (1992)

gui.data.Eind     = gui.data.indenter_material_ym * 10^9; % Young's modulus of of indenter material (in Pa)
gui.data.nuind    = gui.data.indenter_material_pr; % Poisson's coefficient of indenter material
gui.data.Eind_red = (gui.data.Eind / (1-gui.data.nuind^2)); % Reduced Young's modulus of diamond. See in Fischer-Cripps "Nanoindentation 2nd Ed.".

% Effective reduced Young's modulus (sample+indenter) in GPa
gui.results.Eeff_red = ((pi^0.5)/(2*gui.data.beta)).* ...
    10^6.*gui.data.S.*(1./sqrt(gui.results.Ac));

% Reduced Young's modulus of the sample in GPa (no indenter's contribution)
gui.results.Esample_red = ((1./gui.results.Eeff_red) - ...
    (1/(1e-9*gui.data.Eind_red))).^-1;

% Young's modulus of the sample in GPa
gui.results.Esample = gui.results.Esample_red * (1-gui.data.nuf.^2);

guidata(gcf, gui);

end