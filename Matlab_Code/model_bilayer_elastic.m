%% Copyright 2014 MERCIER David
function model_bilayer_elastic
%% Function used to calculate the bilayer elastic model
gui = guidata(gcf);
gui.results.Ef_red_solfit = 0;

%% Refreshing the GUI
if (gui.variables.y_axis ~= 3 && gui.variables.y_axis ~= 4)
    set(gui.handles.value_bilayermodel_GUI,   'Value', 1);
    set(gui.handles.value_multilayermodel_GUI,'Value', 1);
    set(gui.handles.cb_corr_thickness_GUI,    'Value', 0);
    set(gui.handles.title_bilayermodel_GUI,   'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,   'Visible', 'off');
    set(gui.handles.title_multilayermodel_GUI,'Visible', 'off');
    set(gui.handles.value_multilayermodel_GUI,'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,    'Visible', 'off');
    
else
    set(gui.handles.title_bilayermodel_GUI, 'Visible', 'on');
    set(gui.handles.value_bilayermodel_GUI, 'Visible', 'on');
    set(gui.handles.cb_corr_thickness_GUI,  'Visible', 'on');
    
end

%% Setting variables & parameters
gui.data.Es_red = gui.data.Es / (1-gui.data.nus^2);  % Reduced Young's modulus of the substrate (in GPa)

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    gui.results.t_corr = gui.data.t - (gui.results.hc./3);
    
else
    gui.results.t_corr = gui.data.t;
    
end

gui.axis.legend2 = 'Results with the bilayer model';

%% Optimization of Young's modulus of the thin film
if gui.variables.val2 ~= 1
    if gui.variables.y_axis == 3
        x = gui.results.t_corr./gui.results.ac;
        gui.data.phigao1 = (2/pi).*atan(x)+(x./pi).*log((1+(x).^2)./(x).^2); % Hay et al. (2011)
        gui.data.nuc     = 1-(((1-gui.data.nus)*(1-gui.data.nuf))./(1-(1-gui.data.phigao1)*gui.data.nuf-(gui.data.phigao1*gui.data.nus))); % Hay et al. (2011)  - Poisson's coefficient of the composite (film + substrate)
        gui.data.phigao0 = (2.*atan(x)./pi) + ((1./(2.*pi.*(1-gui.data.nuc))).* (((1-2*gui.data.nuc).*x.*log(1+(1./x).^2)) - (x./(1+(x).^2))));
        guidata(gcf, gui);
        
        if gui.variables.val2 == 2 %Doerner & Nix (1986) modified by King (1987)
            gui.data.alpha         = 0.25;
            gui.data.k_DN          = -gui.data.alpha.*x;
            bilayer_model = @(Ef_red_sol, x) ...
                (1e-9*(((1./(1e9*Ef_red_sol))*(1-exp(gui.data.k_DN)))+((1./gui.data.Es_red)*(exp(gui.data.k_DN)))).^-1);
            
        elseif gui.variables.val2 == 3 %Gao et al. (1992)
            bilayer_model = @(Ef_red_sol, x) ...
                (1e-9*((((1e9*Ef_red_sol)-gui.data.Es_red).*gui.data.phigao0)+gui.data.Es_red));
            
            
        elseif gui.variables.val2 == 4 %Bec et al. (2006)
            x             = gui.data.h;
            bilayer_model = @(Ef_red_sol, x) ...
                (1e-9*(((2.*gui.results.ac)./(1+2.*(gui.results.t_corr)./(pi.*gui.results.ac))) .* ...
                (((gui.results.t_corr)./(pi.*gui.results.ac.^2.*1e9*Ef_red_sol) + ...
                (1./(2.*gui.results.ac.*gui.data.Es_red))))).^-1);
            
        elseif gui.variables.val2 == 5 %Hay et al. (2011)
            gui.data.F             = 0.626;
            bilayer_model = @(Ef_red_sol, x) ...
                ((1e-9*((2.*(1+gui.data.nuc)))./(((1-gui.data.phigao0) .* ...
                (1./((gui.data.Es./(2.*(1+gui.data.nus)))))) + ...
                (gui.data.phigao0.*(1./(1e9*(Ef_red_sol.*(1-gui.data.nuf.^2))./(2.*(1+gui.data.nuf)))))))./(1-gui.data.nuc.^2));
            
        elseif gui.variables.val2 == 6 %Perriot et al. (2003)
            model_perriot_barthel;
            gui = guidata(gcf); guidata(gcf, gui);
            
        elseif gui.variables.val2 == 7 % Mencik et al. (linear model) (1997)
            model_mencik_linear;
            gui = guidata(gcf); guidata(gcf, gui);
            
        end
        
        if gui.variables.val2 < 6
            try
            % Make a starting guess at the solution (Ef in GPa)
            gui.results.Ef_red_sol0 = str2double(get(...
                gui.handles.value_youngfilm1_GUI, 'String'));
            
            OPTIONS = optimset('lsqcurvefit');
            OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
            OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
            OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
            [gui.results.Ef_red_solfit, gui.results.resnorm, gui.results.residual, gui.results.exitflag, gui.results.output, gui.results.lambda, gui.results.jacobian] =...
                lsqcurvefit(bilayer_model, gui.results.Ef_red_sol0, x, gui.results.Esample_red,0, 1000, OPTIONS);
            
            gui.results.Ef_sol_fit = ...
                gui.results.Ef_red_solfit * (1-gui.data.nuf^2);
            
            catch
                commandwindow;
                gui.results.Ef_sol_fit = 0;
            end
            
            %% Calculation of Em with elastic bilayer models
            if gui.variables.val2 == 2 %Doerner & Nix (1986) modified by King (1987)
                gui.results.Em_red = 1e-9 * (((1./(1e9*gui.results.Ef_red_solfit)) * (1-exp(gui.data.k_DN))) + ((1./gui.data.Es_red)*(exp(gui.data.k_DN)))).^-1;
                
            elseif gui.variables.val2 == 3 %Gao et al. (1992)
                gui.results.Em_red = 1e-9 * ((((1e9*gui.results.Ef_red_solfit) - gui.data.Es_red) .* gui.data.phigao0) + gui.data.Es_red);
                
            elseif gui.variables.val2 == 5 % Bec et al. (2006)
                gui.results.Em_red = 1e-9 * (((2.*gui.results.ac)./(1+2.*(gui.results.t_corr)./(pi.*gui.results.ac))) .* ...
                    ((gui.results.t_corr./(pi.*gui.results.ac.^2.*(1e9*gui.results.Ef_red_solfit)) + (1./(2.*gui.results.ac*gui.data.Es_red))))).^-1;
                
            elseif gui.variables.val2 == 6 % Hay et al. (2011)
                gui.results.Em_red =((1e-9 * ((2.*(1+gui.data.nuc)))./(((1-gui.data.phigao0) .* (1./((gui.data.Es./(2.*(1+gui.data.nus)))))) + ...
                    (gui.data.phigao0.*(1./(1e9*(gui.results.Ef_red_solfit.*(1-gui.data.nuf.^2))./(2.*(1+gui.data.nuf))))))))./(1-gui.data.nuc.^2);
                
            end
            
            gui.results.Em = gui.results.Em_red*(1-gui.data.nuf.^2);  % Em in GPa
        end
        
        %% Calculation of Ef with elastic bilayer models and Esample_red
    elseif gui.variables.y_axis == 4
        x = (gui.results.t_corr)./gui.results.ac;
        gui.data.phigao1 = (2/pi).*atan(x)+(x./pi).*log((1+(x).^2)./(x).^2); % Hay et al. (2011)
        gui.data.nuc     = 1-(((1-gui.data.nus)*(1-gui.data.nuf))./(1-(1-gui.data.phigao1)*gui.data.nuf-(gui.data.phigao1*gui.data.nus))); % Hay et al. (2011) - Poisson's coefficient of the composite (film + substrate)
        gui.data.phigao0 = (2.*atan(x)./pi) + ((1./(2.*pi.*(1-gui.data.nuc))).* (((1-2*gui.data.nuc).*x.*log(1+(1./x).^2)) - (x./(1+(x).^2))));
        
        if gui.variables.val2 == 2 % Doerner & Nix (1986) modified by King (1987)
            gui.data.alpha  = 0.25;
            gui.data.k_DN   = -gui.data.alpha.*x;
            gui.results.Ef_red = 1e-9*(((1./(1e9.*gui.results.Esample_red)) - ((1./gui.data.Es_red)*(exp(gui.data.k_DN))))./(1-exp(gui.data.k_DN))).^-1;
            
        elseif gui.variables.val2 == 3 % Gao et al. (1992)
            gui.results.Ef_red = 1e-9*((((1e9.*gui.results.Esample_red)-gui.data.Es_red)./gui.data.phigao0) + gui.data.Es_red);
            
        elseif gui.variables.val2 == 4 % Bec et al. (2006)
            gui.results.Ef_red = 1e-9 * ...
                (((pi.*gui.results.ac.^2)./(gui.results.t_corr)) .* ...
                (((1./(1e9.*gui.results.Esample_red)) .* ...
                (((1+2.*(gui.results.t_corr)./(pi.*gui.results.ac)))./(2.*gui.results.ac))) - ...
                (1./(2.*gui.results.ac.*gui.data.Es_red)))).^-1;
            
        elseif gui.variables.val2 == 5 % Hay et al. (2011)
            F      = 0.626;
            mueq   = gui.results.Esample./(2.*(1+gui.data.nuc));
            mus    = 1e-9.*gui.data.Es./(2.*(1+gui.data.nus));
            A_Hay  = F.*gui.data.phigao0;
            B_Hay  = mus - (((F.*gui.data.phigao0.^2) - ...
                gui.data.phigao0+1).*mueq);
            C_Hay  = -gui.data.phigao0.*mueq.*mus;
            muf    = (-B_Hay+(B_Hay.^2-(4.*A_Hay.*C_Hay)).^0.5) ./ ...
                (2.*A_Hay);
            Ef     = (2.*muf.*(1+gui.data.nuf));
            gui.results.Ef_red = Ef./(1-gui.data.nuf^2);  % Ef in GPa
            
        elseif gui.variables.val2 == 6 % Perriot et al. (2003)
            model_perriot_barthel;
            gui = guidata(gcf); guidata(gcf, gui);
            
        elseif gui.variables.val2 == 7 % Mencik et al. (linear model) (1997)
            model_mencik_linear;
            gui = guidata(gcf); guidata(gcf, gui);
        end
        gui.results.Ef = gui.results.Ef_red.*(1 - gui.data.nuf^2);
        
    end
    
elseif gui.variables.val2 == 1 || gui.variables.y_axis == 5 || ...
        gui.variables.val5 == 1 || gui.variables.y_axis == 2 % No Bilayer Model
    
    % Preallocation
    gui.results.Ef     = NaN(length(gui.data.h), 1);
    gui.results.Ef_red = NaN(length(gui.data.h), 1);
    gui.results.Em_red = NaN(length(gui.data.h), 1);
    
    for ii = 1:1:length(gui.data.h)
        gui.results.Ef(ii)      = 0;
        gui.results.Ef          = gui.results.Ef.';
        gui.results.Ef_red(ii)  = 0;
        gui.results.Ef_red      = gui.results.Ef_red.';
        gui.results.Ef_sol_fit  = 0;
        gui.results.Em_red(ii)  = 0;
        gui.results.Em_red      = gui.results.Em_red.';
    end
    
end

set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
guidata(gcf, gui);

%% Calculation of hardness
gui.results.H = model_hardness(gui.data.P, gui.results.Ac);

guidata(gcf, gui);

end
