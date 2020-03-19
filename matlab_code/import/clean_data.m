%% Copyright 2014 MERCIER David
function clean_data
%% Function used to correct data (minimum displacement, CSM correction...)
gui = guidata(gcf);

% Displacement in nm
% Load in mN
% Stiffness in mN/nm
% Compliance in um/mN

% Correction of data (minimum and maximum depths)
if gui.flag.flag_data == 0
    gui.flag.warnText = 'Import data first !';
    gui.flag.wrong_inputs = 1;
    
else
    unit_data;
    gui = guidata(gcf); guidata(gcf, gui);
    
    gui.data.min_depth = ...
        str2double(get(gui.handles.value_mindepth_GUI, 'String'));
    gui.data.max_depth = ...
        str2double(get(gui.handles.value_maxdepth_GUI, 'String'));
    gui.flag.wrong_inputs = 0;
    
    if gui.data.min_depth < gui.data.max_depth && ...
            gui.data.min_depth + 1 >= min(gui.data.h_init) && ...
            gui.data.max_depth > 0 && ...
            gui.data.max_depth - 1 <= max(gui.data.h_init)
    else
        delete(gui.handles.h_waitbar);
        set(gui.handles.value_mindepth_GUI, ...
            'String', round(min(gui.data.h_init)));
        set(gui.handles.value_maxdepth_GUI, ...
            'String', round(max(gui.data.h_init)));
        gui.data.min_depth = round(min(gui.data.h_init));
        gui.data.max_depth = round(max(gui.data.h_init));
        gui.flag.warnText = ...
            ('Wrong inputs for minimum and maximum depth values !');
        gui.flag.wrong_inputs = 1;
    end
    
    if ~gui.flag.wrong_inputs
        if isnan(gui.data.max_depth) == 0 && ...
                isnan(gui.data.min_depth) == 0 && ...
                isempty(gui.data.max_depth) == 0 && ...
                isempty(gui.data.min_depth) == 0
        else
            delete(gui.handles.h_waitbar);
            set(gui.handles.value_mindepth_GUI, ...
                'String', round(min(gui.data.h_init)));
            set(gui.handles.value_maxdepth_GUI, ...
                'String', round(max(gui.data.h_init)));
            gui.data.min_depth = round(min(gui.data.h_init));
            gui.data.max_depth = round(max(gui.data.h_init));
            gui.flag.warnText = ...
                ('Wrong inputs for minimum and maximum depth values !');
            gui.flag.wrong_inputs = 1;
        end
    end
    
    if ~gui.flag.wrong_inputs
        %Remove data below a minimum displacement
        h_set_min = (gui.data.h_init_f > (gui.data.min_depth*gui.data.dispFact));
        gui.data.h_init_f(h_set_min==0) = 0;
        gui.data.delta_h_init_f(h_set_min==0) = 0;
        gui.data.P_init_f(h_set_min==0) = 0;
        gui.data.delta_P_init_f(h_set_min==0) = 0;
        gui.data.S_init_f(h_set_min==0) = 0;
        gui.data.delta_S_init_f(h_set_min==0) = 0;
        
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
            h_int(ii-row(1)+1)       = gui.data.h_init_f(ii);
            delta_h_int(ii-row(1)+1) = gui.data.delta_h_init_f(ii);
            
            P_int(ii-row(1)+1)       = gui.data.P_init_f(ii);
            delta_P_int(ii-row(1)+1) = gui.data.delta_P_init_f(ii);
            
            S_int(ii-row(1)+1)       = gui.data.S_init_f(ii);
            delta_S_int(ii-row(1)+1) = gui.data.delta_S_init_f(ii);
        end
        
        h_int = h_int.';
        delta_h_int = delta_h_int.';
        P_int = P_int.';
        delta_P_int = delta_P_int.';
        S_int = S_int.';
        delta_S_int = delta_S_int.';
        
        % Remove data below a maximum displacement
        h_set_max = (h_int < (gui.data.max_depth*gui.data.dispFact));
        
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
        
        % Value of the frame compliance (in um/mN) in case data (displacement and stiffness)
        % from nanoindentation tests are not corrected.
        % See Fischer-Cripps A.C. (2006). - DOI: 10.1016/j.surfcoat.2005.03.018
        gui.config.data.frame_compliance =  ...
            str2double(get(gui.handles.value_frame_compliance_GUI, 'String'));
        frameComp = 1e3*gui.config.data.frame_compliance; % Convert from um/mN to nm/mN
        
        for ii = row(1):(max(row))
            % With frame compliance correction
            h_FrameCorrected = h_int(ii) - P_int(ii)*frameComp;
            if h_FrameCorrected > 0
                gui.data.h_final(ii) = h_FrameCorrected;
                gui.data.delta_h_final(ii) = delta_h_int(ii);
                
                gui.data.P_final(ii) = P_int(ii);
                gui.data.delta_P_final(ii) = delta_P_int(ii);
                
                % With frame compliance correction
                gui.data.S_final(ii) = ((1/S_int(ii))-frameComp)^-1;
                gui.data.delta_S_final(ii) = delta_S_int(ii);
            else
                gui.data.h_final(ii) = 0;
                gui.data.delta_h_final(ii) = 0;
                gui.data.P_final(ii) = 0;
                gui.data.delta_P_final(ii) = 0;
                gui.data.S_final(ii) = 0;
                gui.data.delta_S_final(ii) = 0;
                disp('Wrong input for the frame compliance or negative load / displacement values!');
            end
            
            if ~gui.flag.wrong_inputs
                gui.data.h = gui.data.h_final.';
                gui.data.delta_h = gui.data.delta_h_final.'; % in nm
                
                gui.data.P = gui.data.P_final.';
                gui.data.delta_P = gui.data.delta_P_final.'; % in mN
                
                gui.data.S = gui.data.S_final.';
                gui.data.delta_S = gui.data.delta_S_final.'; % in mN/nm
            end
        end
        
    end
end
guidata(gcf, gui);

end