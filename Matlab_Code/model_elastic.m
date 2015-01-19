%% Copyright 2014 MERCIER David
function model_elastic
%% Function used for the calculation of the elastic model
gui = guidata(gcf);

%% Constant definition & Initialization
gui.data.Eind     = gui.data.indenter_material_ym * 10^9; % Young's modulus of of indenter material (in Pa)
gui.data.nuind    = gui.data.indenter_material_pr; % Poisson's coefficient of indenter material
gui.data.Eind_red = (gui.data.Eind / (1-gui.data.nuind^2)); % Reduced Young's modulus of diamond. See in Fischer-Cripps "Nanoindentation 2nd Ed.".
gui.data.aloubet  = 1.24;                 % alpha of Loubet's model. See in Guillonneau et al. (2013).

%% Energy calculation ==> Area below load-displacement curve
gui.results.W = 1e-6 * trapz(gui.data.h, gui.data.P); % in µJ / 1J=1N.m

%% Fit of the load-displacement curve
[k_fit, gui.results.P_fit] = load_displacement_fit(...
    gui.variables.loaddisp_model, gui.data.h, gui.data.P);
gui.results.fac_fit = k_fit(1);
gui.results.exp_fit = k_fit(2);

%% Corrections parameters definition
% epsilon from Oliver et al. (2003) (epsilon = 1 for flat punch)
% beta from King (1987)
% gamma from Hay et al. (1999)

if gui.variables.val0 == 1 % Berkovich indenter
    gui.data.epsilon  = 0.72;   % See in Pharr et al. (1992).
    gui.data.h_tip    = gui.data.h_Berk;
    gui.data.theta    = 65.3;   % Semi-angle from the apex (in degrees)
    gui.data.theta_eq = 70.32;  % Equivalent cone angle (in degrees)
    
    if gui.variables.King_correction == 1
        gui.data.beta  = 1.167; % 1.034 without the contribution of 2/(pi^0.5). See in Pharr et al. (1992).
    end
    
    if gui.variables.Hay_correction == 1
        % 1st version of gamma
        % gui.data.gamma = 1+((1-2*nuf)/(4*(1-nuf)*tand(gui.data.theta_eq)));
        gui.data.gamma = pi * (((pi/4) + ...
            (0.15483073.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf))))) / ...
            ((pi/2)-(0.83119312.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf)))))^2);
    end
    
elseif gui.variables.val0 == 2; % Vickers indenter
    gui.data.epsilon  = 0.72; % Oliver & Pharr's  constant. See in Pharr et al. (1992).
    gui.data.h_tip    = gui.data.h_Vick;
    gui.data.theta    = 68;  % Semi-angle from the apex (in degrees)
    gui.data.theta_eq = 70.2996;  % Equivalent cone angle (in degrees)
    
    if gui.variables.King_correction == 1
        gui.data.beta  = 1.142; % 1.012 without the contribution of 2/(pi^0.5). See in Pharr et al. (1992).
    end
    
    if gui.variables.Hay_correction == 1
        gui.data.gamma = pi*(((pi/4) + ...
            (0.15483073.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf))))) / ...
            ((pi/2)-(0.83119312.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf)))))^2);
    end
    
elseif gui.variables.val0 == 3  % Conical indenter
    gui.data.epsilon  = 0.75; % Oliver & Pharr's constant. See in Pharr et al. (1992).
    gui.data.h_tip    = gui.data.h_Coni;
    gui.data.theta_eq = gui.data.Ang;
    
    if gui.variables.King_correction == 1
        gui.data.beta  = 1.129; % 1.000 without the contribution of 2/(pi^0.5). See in Pharr et al. (1992).
    end
    
    if gui.variables.Hay_correction == 1
        gui.data.gamma = pi * (((pi/4) + ...
            (0.15483073.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf))))) / ...
            ((pi/2)-(0.83119312.*cotd(gui.data.theta_eq) * ...
            ((1-2*gui.data.nuf)/(4*(1-gui.data.nuf)))))^2);
    end
end

%% Calculation of hc (contact depth), Ac (contact area), a (contact radius), Eeff_red (effective reduced Young's modulus)
% Contact depth calculation in nm
if gui.variables.val1 == 1 % Doerner et al. (1986)
    gui.results.hc = (gui.data.h+gui.data.h_tip) - ...
        (gui.data.P./gui.data.S);
    
elseif gui.variables.val1 == 2 % Oliver et al. (1992)
    gui.results.hc = (gui.data.h+gui.data.h_tip) - ...
        (gui.data.epsilon.*(gui.data.P./gui.data.S));
    
elseif gui.variables.val1 == 3 % Loubet et al. (1992)
    gui.results.hc = gui.data.aloubet .* ...
        (gui.data.h - (gui.data.P./gui.data.S) + gui.data.h_tip);
    
end

% Contact area calculation in nm2
% Berkovich & Vickers indenters
if gui.variables.val0 == 1 || gui.variables.val0 == 2
    gui.results.Ac = gui.data.C1.*(gui.results.hc.^2) + ...
        gui.data.C2.*(gui.results.hc.^1) + ...
        gui.data.C3.*(gui.results.hc.^0.5) + ...
        gui.data.C4.*(gui.results.hc.^0.25) + ...
        gui.data.C5.*(gui.results.hc.^0.125);
    
    % Conical indenter
elseif gui.variables.val0 == 3
    gui.results.Ac = pi * (gui.results.hc.^2) * tand(gui.data.theta_eq)^2;
    
end

% Contact radius calculation in nm
gui.results.ac = sqrt(gui.results.Ac./pi);

% Effective reduced Young's modulus (sample+indenter) in GPa
gui.results.Eeff_red = (1./(gui.data.beta .* gui.data.gamma)).* ...
    10^6.*gui.data.S.*(1./sqrt(gui.results.Ac));

%% Young's modulus calculation - See in Pharr et al. (1992)
% Reduced Young's modulus of the sample in GPa (no indenter's contribution)
gui.results.Esample_red = ((1./gui.results.Eeff_red) - (1/(1e-9*gui.data.Eind_red))).^-1;

% Young's modulus of the sample in GPa
gui.results.Esample = gui.results.Esample_red * (1-gui.data.nuf.^2);

guidata(gcf, gui);

end