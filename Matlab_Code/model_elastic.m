%% Copyright 2014 MERCIER David
function model_elastic
%% Function used for the calculation of the reduced Young's modulus
gui = guidata(gcf);

%% Constants definition
theta_eq = str2num(gui.data.indenter_tip_angle); % Equivalent cone angle (in degrees)

if gui.variables.King_correction == 1 % See in King (1987)
    if gui.variables.val0 == 1 % Berkovich indenter
        beta = gui.config.numerics.betaBerkovich_King;
        
    elseif gui.variables.val0 == 2; % Vickers indenter
        beta = gui.config.numerics.betaVickers_King;
        
    elseif gui.variables.val0 == 3  % Cube-Corner indenter
        beta = gui.config.numerics.betaVickers_King;
        
    elseif gui.variables.val0 == 4  % Conical indenter
        beta = gui.config.numerics.betaConical_King;
    end
elseif gui.variables.King_correction == 2 % See in Hay (1999)
    if theta_eq > 60
        beta = pi * (((pi/4) + ...
            (0.15483073*cotd(theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf))))) / ...
            ((pi/2)-(0.83119312*cotd(theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf)))))^2);
    else
        beta = 1 + ((1-2*gui.data.nuf) / ...
            (4*(1-gui.data.nuf) * tand(theta_eq)));
    end
end

%% Young's modulus calculation - See in Pharr et al. (1992)
gui.data.Eind     = gui.data.indenter_material_ym * 10^9; % Young's modulus of of indenter material (in Pa)
gui.data.nuind    = gui.data.indenter_material_pr; % Poisson's coefficient of indenter material
gui.data.Eind_red = (gui.data.Eind / (1-gui.data.nuind^2)); % Reduced Young's modulus of diamond. See in Fischer-Cripps "Nanoindentation 2nd Ed.".

% Effective reduced Young's modulus (sample+indenter) in GPa
gui.results.Eeff_red = ((pi^0.5)/(2*beta)).* ...
    10^6.*gui.data.S.*(1./sqrt(gui.results.Ac));

% Reduced Young's modulus of the sample in GPa (no indenter's contribution)
gui.results.Esample_red = ((1./gui.results.Eeff_red) - ...
    (1/(1e-9*gui.data.Eind_red))).^-1;

% Young's modulus of the sample in GPa
gui.results.Esample = gui.results.Esample_red * (1-gui.data.nuf.^2);

guidata(gcf, gui);

end