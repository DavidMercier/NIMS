%% Copyright 2014 MERCIER David
function model_multilayer_elastic
%% Function used to calculate Young's modulus in multilayer system with the model of Mercier et al. (2010)
gui = guidata(gcf);

%% Refreshing the GUI
if (gui.variables.y_axis ~= 4 && gui.variables.y_axis ~= 5)
    set(gui.handles.title_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'off');
    set(gui.handles.value_multilayermodel_GUI, 'Value', 1);
    set(gui.handles.value_bilayermodel_GUI,    'Value', 1);
    set(gui.handles.cb_corr_thickness_GUI,     'Value', 0);
    
else
    set(gui.handles.title_multilayermodel_GUI, 'Visible', 'on');
    set(gui.handles.value_multilayermodel_GUI, 'Visible', 'on');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'on');
    
end

%% Setting variables & parameters
gui.data.Es_red = gui.data.Es / (1-gui.data.nus^2);   % Reduced Young's modulus of the substrate (in GPa)
gui.data.E0_red = gui.data.E0 / (1-gui.data.nuf0^2);  % Reduced Young's modulus of the film 0 (in GPa)
gui.data.E1_red = gui.data.E1 / (1-gui.data.nuf1^2);  % Reduced Young's modulus of the film 1 (in GPa)
gui.results.ac2 = gui.results.ac;
gui.axis.legend2 = 'Results with the multilayer model';

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    gui.results.t2_corr = gui.data.t2 - (gui.results.hc ./ 3);
    
else
    gui.results.t2_corr = gui.data.t2;
    
end

if gui.variables.num_thinfilm == 4
    gui.results.ac1 = gui.results.ac2 + ((2.*gui.data.t2)./pi);
    gui.results.t1_corr = gui.data.t1;
    
elseif gui.variables.num_thinfilm == 3
    gui.results.ac1 = gui.results.ac;
    
    if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
        gui.results.t1_corr = gui.data.t1 - (gui.results.hc ./ 3);
        
    else
        gui.results.t1_corr = gui.data.t1;
        
    end
end
gui.results.ac0     = gui.results.ac1 + ((2.*gui.data.t1)./pi);
gui.results.t0_corr = gui.data.t0;

%% Optimization of Young's modulus of the thin film
if gui.variables.val2_mm ~= 1
    
    x = gui.data.h; 
    
    % 2 Films + Substrat
    if gui.variables.num_thinfilm == 3 && gui.variables.val2_mm == 2 % Mercier et al. (2010)
        multilayer_model = @(Ef_red_sol, x) ...
            1e-9 .* (((2.*gui.results.ac1.*((gui.results.t1_corr./(((pi.*gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr)).*1e9*Ef_red_sol)) + ...
            (gui.results.t0_corr./(((pi.*gui.results.ac0.^2)+(2.*gui.results.ac0.*gui.results.t0_corr)).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red)))).^-1));
        
        Ef_red_sol0 = (str2double (get(gui.handles.value_youngfilm1_GUI,'String')));                    % Make a starting guess at the solution (Ef in GPa)
        
        %3 Films + Substrat
    elseif gui.variables.num_thinfilm == 4 && gui.variables.val2_mm == 2 % Mercier et al. (2010)
        multilayer_model = @(Ef_red_sol, x) ...
            1e-9 .* (((2.*gui.results.ac2.*((gui.results.t2_corr./(((pi.*gui.results.ac2.^2)+(2.*gui.results.ac2.*gui.results.t2_corr)).*1e9*Ef_red_sol)) + ...
            (gui.results.t1_corr./(((pi.*gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr)).*gui.data.E1_red)) + ...
            (gui.results.t0_corr./(((pi.*gui.results.ac0.^2)+(2.*gui.results.ac0.*gui.results.t0_corr)).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red)))).^-1));
        
        Ef_red_sol0 = (str2double(get(gui.handles.value_youngfilm2_GUI, 'String')));                    % Make a starting guess at the solution (Ef in GPa)
        
    end
    
    OPTIONS = optimset('lsqcurvefit');
    OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
    OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
    OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
    [gui.results.Ef_red_solfit, gui.results.resnorm, gui.results.residual, gui.results.exitflag, gui.results.output, gui.results.lambda, gui.results.jacobian] = ...
        lsqcurvefit(multilayer_model, Ef_red_sol0,x, gui.results.Esample_red, 0, 1000, OPTIONS);
    
    gui.results.Ef_sol_fit = gui.results.Ef_red_solfit * (1-gui.data.nuf^2);
    
    %% Calculation of Ef with elastic multilayer model and Esample_red
    % 2 Films + Substrat
    if gui.variables.num_thinfilm == 3 && gui.variables.val2_mm == 2 % Mercier et al. (2010)
        gui.results.Ef_red = 1e-9.*(((((pi.*gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr))./gui.results.t1_corr).*((1./(2.*gui.results.ac1.*(1e9.*gui.results.Esample_red))) - ...
            ((gui.results.t0_corr./((pi.*(gui.results.ac0.^2)+2.*gui.results.t0_corr.*gui.results.ac0).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red))))).^-1);
        
        % 3 Films + Substrat
    elseif gui.variables.num_thinfilm == 4 && gui.variables.val2_mm == 2 % Mercier et al. (2010)
        gui.results.Ef_red = 1e-9.*(((((pi.*gui.results.ac2.^2)+(2.*gui.results.ac2.*gui.results.t2_corr))./gui.results.t2_corr).*((1./(2.*gui.results.ac2.*(1e9.*gui.results.Esample_red))) - ...
            ((gui.results.t1_corr./((pi.*(gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr)).*gui.data.E1_red)) + ...
            (gui.results.t0_corr./((pi.*(gui.results.ac0.^2)+2.*gui.results.t0_corr.*gui.results.ac0).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red))))).^-1);
        
    end
    
    gui.results.Ef = gui.results.Ef_red*(1-gui.data.nuf^2);  % Ef in GPa
    
    %% Calculation of Em with elastic multilayer model
    % 2 Films + Substrat
    if gui.variables.num_thinfilm == 3 || gui.variables.val2_mm == 1 % Mercier et al. (2010)
        gui.results.Em_red = 1e-9 .* ((2.*gui.results.ac1.*((gui.results.t1_corr./(((pi.*gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr)).*1e9*gui.results.Ef_red_solfit)) + ...
            (gui.results.t0_corr./(((pi.*gui.results.ac0.^2)+(2.*gui.results.ac0.*gui.results.t0_corr)).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red)))).^-1);
        
        % 3 Films + Substrat
    elseif gui.variables.num_thinfilm == 4 || gui.variables.val2_mm == 1 % Mercier et al. (2010)
        gui.results.Em_red = 1e-9 .* ((2.*gui.results.ac2.*((gui.results.t2_corr./(((pi.*gui.results.ac2.^2)+(2.*gui.results.ac2.*gui.results.t2_corr)).*1e9*gui.results.Ef_red_solfit)) + ...
            (gui.results.t1_corr./(((pi.*gui.results.ac1.^2)+(2.*gui.results.ac1.*gui.results.t1_corr)).*gui.data.E1_red)) + ...
            (gui.results.t0_corr./(((pi.*gui.results.ac0.^2)+(2.*gui.results.ac0.*gui.results.t0_corr)).*gui.data.E0_red)) + ...
            (1./((2.*(gui.results.ac0+((2.*gui.results.t0_corr)./pi))).*gui.data.Es_red)))).^-1);
        
    end
    
    gui.results.Em = gui.results.Em_red * (1-gui.data.nuf.^2); % Em in GPa
    
elseif gui.variables.val2_mm == 1
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