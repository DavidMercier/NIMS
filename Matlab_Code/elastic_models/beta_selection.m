%% Copyright 2014 MERCIER David
function beta_Val = beta_selection
%% Function used for the set the value of the beta parameter

gui = guidata(gcf);

BetaCorr = gui.variables.King_correction;
Val0 = gui.variables.val0;

% Equivalent cone angle (in degrees)
theta_eq = str2double(gui.data.indenter_tip_angle);

if BetaCorr == 1 % See in King (1987)
    if Val0 == 1 % Berkovich indenter
        beta_Val = gui.config.numerics.betaBerkovich_King;
        
    elseif Val0 == 2; % Vickers indenter
        beta_Val = gui.config.numerics.betaVickers_King;
        
    elseif Val0 == 3  % Cube-Corner indenter
        beta_Val = gui.config.numerics.betaVickers_King;
        
    elseif Val0 == 4  % Conical indenter
        beta_Val = gui.config.numerics.betaConical_King;
    end
elseif BetaCorr == 2 % See in Hay (1999)
    beta_Val = beta_hay(theta_eq, gui.data.nuf);
end

gui.config.numerics.beta_Val = beta_Val;

guidata(gcf, gui);

end