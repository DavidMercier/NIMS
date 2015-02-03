%% Copyright 2014 MERCIER David
function model_bilayer_elastic
%% Function used to calculate the bilayer elastic model
gui = guidata(gcf);
gui.results.Ef_red_sol_fit = 0;
gui.results.Em_red = 0;
gui.results.Ef_red = 0;
gui.results.t_corr = 0;
guidata(gcf, gui);

%% Setting variables & parameters
gui.data.Es_red = gui.data.Es / (1-gui.data.nus^2);  % Reduced Young's modulus of the substrate (in GPa)

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    gui.results.t_corr = gui.data.t - (gui.results.hc./3);
    
else
    gui.results.t_corr = gui.data.t;
    
end

gui.axis.legend2 = 'Results with the bilayer model';
guidata(gcf, gui);

%% Optimization of Young's modulus of the thin film
if gui.variables.val2 ~= 1
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
	
        OPTIONS = optimset('lsqcurvefit');
		OPTIONS = optimset(OPTIONS, 'TolFun',  gui.config.numerics.TolFun_value);
		OPTIONS = optimset(OPTIONS, 'TolX',    gui.config.numerics.TolX_value);
		OPTIONS = optimset(OPTIONS, 'MaxIter', gui.config.numerics.MaxIter_value);

        if gui.variables.val2 == 2 %Doerner & Nix (1986) modified by King (1987)
            model_doerner_nix_king(OPTIONS);
        elseif gui.variables.val2 == 3 %Gao et al. (1992) (for flat cylindrical indentation test...)
            model_gao(OPTIONS);
        elseif gui.variables.val2 == 4 %Bec et al. (2006)
            model_bec(OPTIONS);
        elseif gui.variables.val2 == 5 %Hay et al. (2011)
            model_hay(OPTIONS);
        elseif gui.variables.val2 == 6 %Perriot et al. (2003)
            model_perriot_barthel(OPTIONS);
        elseif gui.variables.val2 == 7 % Mencik et al. (linear model) (1997)
            model_mencik_linear(OPTIONS);
        elseif gui.variables.val2 == 8 % Mencik et al. (exponential model) (1997)
            model_mencik_exponential(OPTIONS);
        elseif gui.variables.val2 == 9 % Mencik et al. (reciprocal exponential model) (1997)
            model_mencik_reciprocal_exponential(OPTIONS);
        end
        
        gui = guidata(gcf); guidata(gcf, gui);
        gui.results.Em = gui.results.Em_red*(1 - gui.data.nuf.^2); % Em in GPa
        gui.results.Ef = gui.results.Ef_red.*(1 - gui.data.nuf^2); % Ef in GPa
        guidata(gcf, gui);
    end
    
elseif gui.variables.val2 == 1 % No Bilayer Model
    
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

end