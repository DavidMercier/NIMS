%% Copyright 2014 MERCIER David
function model_function_area
%% Function used for the calculation of the function area
gui = guidata(gcf);

%% Constants definition
h_tip = str2num(gui.data.indenter_tip_defect); % Tip defect (in nm)
aloubet = gui.config.numerics.alpha_Loubet;

if gui.variables.val0 == 1 % Berkovich indenter
    epsilon = gui.config.numerics.epsilonParaboloidRevolution_OliverPharr;
elseif gui.variables.val0 == 2; % Vickers indenter
    epsilon = gui.config.numerics.epsilonParaboloidRevolution_OliverPharr;
elseif gui.variables.val0 == 3  % Cube-Corner indenter
    epsilon = gui.config.numerics.epsilonParaboloidRevolution_OliverPharr;
elseif gui.variables.val0 == 4  % Conical indenter
    epsilon = gui.config.numerics.epsilonConical_OliverPharr;
end

%% Calculation of hc (contact depth), Ac (contact area) and a (contact radius)
% Contact depth calculation in nm
if gui.variables.val1 == 1 % Doerner et al. (1986)
    gui.results.hc = (gui.data.h + h_tip) - ...
        (gui.data.P./gui.data.S);
elseif gui.variables.val1 == 2 % Oliver et al. (1992)
    gui.results.hc = (gui.data.h + h_tip) - ...
        (epsilon.*(gui.data.P./gui.data.S));
elseif gui.variables.val1 == 3 % Loubet et al. (1992)
    gui.results.hc = aloubet .* ...
        (gui.data.h + h_tip - (gui.data.P./gui.data.S));
end

% Check to avoid negative contact area introducing error in other
% calculations of Young's modulus and hardness
for ii = 1:length(gui.results.hc)
    if gui.results.hc(ii) < 1
        gui.results.hc(ii) = 0;
    end
end

% Contact area calculation in nm2
gui.results.Ac = gui.data.C0.*(gui.results.hc.^2) + ...
    gui.data.C1.*(gui.results.hc.^1) + ...
    gui.data.C2.*(gui.results.hc.^(1/2)) + ...
    gui.data.C3.*(gui.results.hc.^(1/4)) + ...
    gui.data.C4.*(gui.results.hc.^(1/8)) + ...
    gui.data.C5.*(gui.results.hc.^(1/16)) + ...
    gui.data.C6.*(gui.results.hc.^(1/32)) + ...
    gui.data.C7.*(gui.results.hc.^(1/64)) + ...
    gui.data.C8.*(gui.results.hc.^(1/128));

% Check to avoid negative contact area introducing error in other
% calculations of Young's modulus and hardness
for ii = 1:length(gui.results.Ac)
    if gui.results.Ac(ii) < 1
        gui.results.Ac(ii) = 0;
    end
end

% Contact radius calculation in nm
gui.results.ac = sqrt(gui.results.Ac./pi);

guidata(gcf, gui);

end