%% Copyright 2014 MERCIER David
function clean_data
%% Function used to correct data (minimum displacement, CSM correction...)
gui = guidata(gcf);

% Correction of data (minimum and maximum depths)
if gui.flag.flag_data == 0
    gui.flag.wrong_inputs = 1;
    helpdlg('Import data first !','!!!');
    
else
    gui.data.min_depth = str2double(get(gui.handles.value_mindepth_GUI, 'String')); % in nm
    gui.data.max_depth = str2double(get(gui.handles.value_maxdepth_GUI, 'String')); % in nm
    gui.flag.wrong_inputs = 0;
    
    if gui.data.min_depth < gui.data.max_depth && gui.data.min_depth + 1 >= min(gui.data.h_init) && gui.data.max_depth > 0 && gui.data.max_depth - 1 <= max(gui.data.h_init)
    else
        delete(gui.handles.h_waitbar);
        set(gui.handles.value_mindepth_GUI, 'String', round(min(gui.data.h_init))); % in nm
        set(gui.handles.value_maxdepth_GUI, 'String', round(max(gui.data.h_init))); % in nm
        gui.data.min_depth = round(min(gui.data.h_init));
        gui.data.max_depth = round(max(gui.data.h_init));
        warndlg('Wrong inputs for minimum and maximum depth values !', 'Input Error');
        gui.flag.wrong_inputs = 1;
    end
    
    if ~gui.flag.wrong_inputs
        if isnan(gui.data.max_depth) == 0 && isnan(gui.data.min_depth) == 0 && isempty(gui.data.max_depth) == 0 && isempty(gui.data.min_depth) == 0
        else
            delete(gui.handles.h_waitbar);
            set(gui.handles.value_mindepth_GUI, 'String', round(min(gui.data.h_init))); % in nm
            set(gui.handles.value_maxdepth_GUI, 'String', round(max(gui.data.h_init))); % in nm
            gui.data.min_depth = round(min(gui.data.h_init));
            gui.data.max_depth = round(max(gui.data.h_init));
            warndlg('Wrong inputs for minimum and maximum depth values !', 'Input Error');
            gui.flag.wrong_inputs = 1;
        end
    end
    
    if ~gui.flag.wrong_inputs
        h_set_min = (gui.data.h_init > gui.data.min_depth); % Remove data below a minimum displacement
        
        for ii = 1:length(h_set_min)
            [row, col] = find(h_set_min >= 1);
        end
        
        % Preallocation
        h_int       = NaN(max(col), 1);
        delta_h_int = NaN(max(col), 1);
        P_int       = NaN(max(col), 1);
        delta_P_int = NaN(max(col), 1);
        S_int       = NaN(max(col), 1);
        delta_S_int = NaN(max(col), 1);
        
        for ii = row(1):(max(row))
            h_int(ii-row(1)+1)       = gui.data.h_init(ii);
            delta_h_int(ii-row(1)+1) = gui.data.delta_h_init(ii);
            
            P_int(ii-row(1)+1)       = gui.data.P_init(ii);
            delta_P_int(ii-row(1)+1) = gui.data.delta_P_init(ii);
            
            S_int(ii-row(1)+1)       = gui.data.S_init(ii);
            delta_S_int(ii-row(1)+1) = gui.data.delta_S_init(ii);
        end
        
        h_int = h_int.'; delta_h_int = delta_h_int.';
        P_int = P_int.'; delta_P_int = delta_P_int.';
        S_int = S_int.'; delta_S_int = delta_S_int.';
        
        h_set_max = (h_int < gui.data.max_depth); % Remove data below a maximum displacement
        
        clear [row, col];
        for ii = 1:length(h_set_max)
            [row, col] = find(h_set_max == 1);
        end
        
        % Preallocation
        gui.data.h_final       = NaN(max(col), 1);
        gui.data.delta_h_final = NaN(max(col), 1);
        gui.data.P_final       = NaN(max(col), 1);
        gui.data.delta_P_final = NaN(max(col), 1);
        gui.data.S_final       = NaN(max(col), 1);
        gui.data.delta_S_final = NaN(max(col), 1);
        
        for ii = row(1):(max(row))
            gui.data.h_final(ii)       = h_int(ii);
            gui.data.delta_h_final(ii) = delta_h_int(ii);
            
            gui.data.P_final(ii)       = P_int(ii);
            gui.data.delta_P_final(ii) = delta_P_int(ii);
            
            gui.data.S_final(ii)       = S_int(ii);
            gui.data.delta_S_final(ii) = delta_S_int(ii);
            
        end
        
        gui.data.h = gui.data.h_final.'; gui.data.delta_h = gui.data.delta_h_final.'; % in nm
        gui.data.P = gui.data.P_final.'; gui.data.delta_P = gui.data.delta_P_final.'; % in mN
        gui.data.S = gui.data.S_final.'; gui.data.delta_S = gui.data.delta_S_final.'; % in mN/nm
        
    end
    
end

guidata(gcf, gui);

end