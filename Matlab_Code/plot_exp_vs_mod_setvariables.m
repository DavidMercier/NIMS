%% Copyright 2014 MERCIER David
function plot_exp_vs_mod_setvariables
%% Function used to set variables for the plot exp. vs. mod.
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Import data first !','!!!');
    
    %% Initialization
else
    set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
    
    if gui.variables.num_thinfilm == 1 % Only a bulk material
        
        for ii = 1:1:length(gui.data.h)
            gui.results.Ef_red(ii) = 0;
            gui.results.Ef_red     = gui.results.Ef_red.';
            gui.results.Em_red(ii) = 0;
            gui.results.Em_red     = gui.results.Em_red.';
        end
        
        gui.data.t = max(gui.data.h)+1;
        gui.results.Ef_sol_fit = 0;
        
    end
    
    if gui.variables.y_axis == 4
        
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
        gui.axis.xlabelstr = 'Displacement (h) (nm)';
        gui.axis.xmax = round(max(gui.data.h));
        gui.axis.xmin = 0;
        gui.axis.title_str = strcat('Max displacement = ', ...
            num2str(round(max(gui.data.h))), 'nm');
        
    elseif gui.variables.x_axis == 2
        gui.axis.x2plot = gui.results.ac./gui.data.t;
        gui.axis.xlabelstr = 'Contact Radius / Film Thickness(t)';
        gui.axis.xmax = round(max(gui.results.ac./gui.data.t));
        gui.axis.xmin = round(min(gui.results.ac./gui.data.t));
        gui.axis.title_str = strcat('Max displacement = ', ...
            num2str(round(max(gui.data.h))), 'nm');
        
    elseif gui.variables.x_axis == 3
        gui.axis.x2plot = gui.data.h/gui.data.t;
        gui.axis.xlabelstr = 'Displ. (h) / Film Thickness (t)';
        gui.axis.xmax = round(max(gui.data.h/gui.data.t));
        gui.axis.xmin = 0;
        gui.axis.title_str = strcat('Max displacement = ', ...
            num2str(round(max(gui.data.h))), 'nm');
        
    end
    
    if gui.variables.y_axis == 1
        gui.axis.y2plot = gui.data.P;
        gui.axis.delta_y2plot = gui.data.delta_P;
        gui.axis.y2plot_2 = gui.results.P_fit;
        gui.axis.ylabelstr = 'Load (mN)';
        gui.axis.ymax = round(max(gui.data.P.*1000)./10)./100;
        gui.axis.title_str = strcat('Loading work (W)  = ', ...
            num2str(gui.results.W), 'µJ', ' / ', ...
            ' Exposant of the power law fit  = ', ...
            num2str(gui.results.exp_fit));
        
    elseif gui.variables.y_axis == 2
        gui.axis.y2plot = gui.data.S;
        gui.axis.delta_y2plot = gui.data.delta_S;
        gui.axis.ylabelstr = 'Stiffness (mN/nm)';
        gui.axis.ymax = round(max(gui.data.S.*1000)./10)./100;
        gui.axis.title_str = '';
        
    elseif gui.variables.y_axis == 3
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = 0;
        gui.axis.y2plot_2 = gui.results.Em_red;
        gui.axis.ylabelstr = 'Reduced Young''s modulus (sample) (GPa)';
        gui.axis.ymax = mean(gui.results.Esample_red) + ...
            0.3*mean(gui.results.Esample_red);
        gui.axis.title_str = '';
        
    elseif gui.variables.y_axis == 4
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = 0;
        gui.axis.y2plot_2 = gui.results.Ef_red;
        gui.axis.ylabelstr = 'Reduced Young''s modulus (film) vs. Young''s modulus(film + substrate) (GPa)';
        gui.axis.ymax = mean(gui.results.Esample_red) + ...
            0.3*mean(gui.results.Esample_red);
        gui.axis.title_str = '';
        
    elseif gui.variables.y_axis == 5
        gui.axis.y2plot = gui.results.H;
        gui.axis.delta_y2plot = 0;
        gui.axis.ylabelstr = 'Hardness (GPa)';
        gui.axis.ymax = mean(gui.results.H)+0.3*mean(gui.results.H);
        gui.axis.title_str = strcat('Mean Hardness = ', ...
            num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        
    end
    
end

guidata(gcf, gui);

end