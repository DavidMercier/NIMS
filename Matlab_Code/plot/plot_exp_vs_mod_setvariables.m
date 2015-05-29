%% Copyright 2014 MERCIER David
function plot_exp_vs_mod_setvariables
%% Function used to set variables for the plot exp. vs. mod.
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Import data first !','!!!');
    
    %% Initialization
else
    set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
    gui.axis.title_str = '';
    gui.axis.title_str = strcat('Max displacement = ', ...
        num2str(round(max(gui.data.h))), char(gui.data.dispUnit));
    
    if gui.variables.num_thinfilm == 1 % Only a bulk material
        for ii = 1:1:length(gui.data.h)
            gui.results.Ef_red(ii) = 0;
            gui.results.Ef_red     = gui.results.Ef_red.';
            gui.results.Em_red(ii) = 0;
            gui.results.Em_red     = gui.results.Em_red.';
        end
        gui.data.t = max(gui.data.h)+1;
        gui.results.Ef_sol_fit = 0;
        gui.results.Ef_sol = 0;
    end
    
    if gui.variables.y_axis == 5
        for ii = 1:1:length(gui.data.h)
            if gui.data.h(ii) < gui.data.t && ...
                    gui.variables.num_thinfilm == 1
                gui.results.Ef_mean(ii) = gui.results.Ef_red(ii);
            elseif gui.data.h(ii) < gui.data.t && ...
                    gui.variables.num_thinfilm ~= 1
                gui.results.Ef_mean(ii) = gui.results.Ef(ii);
                
            end
        end
        gui.results.Ef_sol = mean(gui.results.Ef_mean);
    end
    
    %% Setting of the plot - Defintion of variables
    if gui.variables.x_axis == 1
        gui.axis.x2plot = gui.data.h;
        gui.axis.xlabelstr = ['Displacement (h) (', char(gui.data.dispUnit),')'];
        gui.axis.xmax = round(max(gui.data.h));
        gui.axis.xmin = 0;
    elseif gui.variables.x_axis == 2
        gui.axis.x2plot = gui.results.ac./gui.data.t;
        gui.axis.xlabelstr = 'Contact Radius / Film Thickness (t)';
        if max(gui.results.ac./gui.data.t) < 1
            gui.axis.xmax = 1;
        else
            gui.axis.xmax = round(max(gui.results.ac./gui.data.t));
        end
        gui.axis.xmin = round(min(gui.results.ac./gui.data.t));
    elseif gui.variables.x_axis == 3
        gui.axis.x2plot = gui.data.h/gui.data.t;
        gui.axis.xlabelstr = 'Displ. (h) / Film Thickness (t)';
        if max(gui.data.h/gui.data.t) < 1
            gui.axis.xmax = 1;
        else
            gui.axis.xmax = round(max(gui.data.h/gui.data.t));
        end
        gui.axis.xmin = 0;
    end
    
    if gui.variables.y_axis == 1
        gui.axis.y2plot = gui.data.P;
        gui.axis.delta_y2plot = gui.data.delta_P;
        gui.axis.y2plot_2 = gui.results.P_fit;
        gui.axis.ylabelstr = ['Load (', char(gui.data.loadUnit),')'];
        gui.axis.ymax = max(gui.data.P);
        gui.axis.title_str = strcat('Loading work (W) = ', ...
            num2str(gui.results.W_microJ), 'µJ', ' / ', ...
            sprintf(' k(fit)= %.2e', ...
            gui.results.fac_fit), ' / ', ...
            ' Exponent n(fit)= ', ...
            num2str(round(100*gui.results.exp_fit)/100));
    elseif gui.variables.y_axis == 2
        gui.axis.y2plot = gui.data.S;
        gui.axis.delta_y2plot = gui.data.delta_S;
        gui.axis.ylabelstr = ['Stiffness (', char(gui.data.stifUnit),')'];
        gui.axis.ymax = max(gui.data.S);
    elseif gui.variables.y_axis == 3
        gui.axis.y2plot = gui.data.P ./ (gui.data.S.^2);
        gui.axis.delta_y2plot = gui.data.delta_P - 2*(gui.data.delta_S);
        gui.axis.ylabelstr = 'Load oved Stiffness squared (1/GPa)';
        gui.axis.ymax = max(gui.axis.y2plot);
    elseif gui.variables.y_axis == 4
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = 0;
        gui.axis.y2plot_2 = gui.results.Em_red;
        gui.axis.ylabelstr = 'Reduced Young''s modulus (sample) (GPa)';
        cleaned_Esample_red = gui.results.Esample_red;
        cleaned_Esample_red(isinf(cleaned_Esample_red)) = [];
        cleaned_Esample_red(isnan(cleaned_Esample_red)) = [];
        cleaned_Esample_red(cleaned_Esample_red < 0) = [];
        gui.axis.ymax = mean(cleaned_Esample_red) + ...
            0.5*mean(cleaned_Esample_red);
    elseif gui.variables.y_axis == 5
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = 0;
        gui.axis.y2plot_2 = gui.results.Ef_red;
        gui.axis.ylabelstr = ['Reduced Young''s modulus (film) vs. ', ...
            'Young''s modulus(film + substrate) (GPa)'];
        cleaned_Esample_red = gui.results.Esample_red;
        cleaned_Esample_red(isinf(cleaned_Esample_red)) = [];
        cleaned_Esample_red(isnan(cleaned_Esample_red)) = [];
        cleaned_Esample_red(cleaned_Esample_red < 0) = [];
        gui.axis.ymax = mean(cleaned_Esample_red) + ...
            0.5*mean(cleaned_Esample_red);
    elseif gui.variables.y_axis == 6
        gui.axis.y2plot = gui.results.H;
        gui.axis.delta_y2plot = 0;
        gui.axis.ylabelstr = 'Hardness (GPa)';
        cleaned_H = gui.results.H;
        cleaned_H(isinf(cleaned_H)) = [];
        cleaned_H(isnan(cleaned_H)) = [];
        cleaned_H(cleaned_H < 0) = [];
        gui.axis.ymax = mean(cleaned_H)+0.5*mean(cleaned_H);
        gui.axis.title_str = strcat('Mean Hardness= ', ...
            num2str(round(mean(cleaned_H.*1000)./10)./100), 'GPa');
    end
    
end

guidata(gcf, gui);

end