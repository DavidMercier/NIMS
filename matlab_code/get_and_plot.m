%% Copyright 2014 MERCIER David
function get_and_plot
%% Function used to get and plot data
gui = guidata(gcf);

if get(gui.handles.value_param2plotinxaxis_GUI, 'Value') == 4 && ...
        get(gui.handles.value_param2plotinyaxis_GUI, 'Value') ~= 6
    set(gui.handles.value_param2plotinxaxis_GUI, 'Value', 1);
    warning('NIMS:HardnessPlot:IncompatibleAxis', ...
        'Sample hardness on the X axis requires Hardness on the Y axis; X axis reset to displacement.');
end

viscoelastic = get(gui.handles.value_param2plotinyaxis_GUI, 'Value') >= 10;
if viscoelastic
    if ~gui.flag.flag_data || ~isfield(gui.data, 'storage_stiffness_init') || ...
            ~isfield(gui.data, 'loss_stiffness_init')
        warndlg('Import a Hysitron DMA file with storage and loss stiffness columns first.', ...
            'Viscoelastic data unavailable');
        return;
    end
    frameCompliance = str2double(get(gui.handles.value_frame_compliance_GUI, 'String'));
    if ~isfinite(frameCompliance) || frameCompliance ~= 0 || ...
            get(gui.handles.cb_CSM_corr_GUI, 'Value') ~= 0
        warndlg('Viscoelastic results require zero frame compliance and CSM correction disabled.', ...
            'Unsupported correction');
        return;
    end
end

if get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 9
    plot_unloading;
    return;
end
set(gui.handles.value_param2plotinxaxis_GUI, 'Enable', 'on');
set(gui.handles.cb_lines_plot_GUI, 'Enable', 'on');
set(gui.handles.value_model_GUI, 'Enable', 'on');
set(gui.handles.value_elastic_models_GUI, 'Enable', 'on');

gui.handles.h_waitbar = waitbar(0, 'Calculations in progress...');
steps = 100;
for step = 1:steps
    waitbar(step / steps, gui.handles.h_waitbar);
end

%% Cleaning of data
gui.results = struct();
guidata(gcf, gui);

clean_data;
gui = guidata(gcf); guidata(gcf, gui);

%% Refreshing the GUI and getting parameters and
refresh_param_GUI;
get_param_GUI;

if ~gui.flag.wrong_inputs
    if gui.flag.flag_no_csm ~= 1 && ~viscoelastic
        CSM_correction;
    end
    
    %% Get parameters
    model_set_parameters;
    gui = guidata(gcf); guidata(gcf, gui);
    if viscoelastic
        gui.variables.val2 = 1;
        selected = find(gui.data.h_init > gui.data.min_depth & ...
            gui.data.h_init < gui.data.max_depth);
        gui.data.h = reshape(gui.data.h_init_f(selected), 1, []);
        gui.data.delta_h = reshape(gui.data.delta_h_init_f(selected), 1, []);
        gui.data.P = reshape(gui.data.P_init_f(selected), 1, []);
        gui.data.delta_P = reshape(gui.data.delta_P_init_f(selected), 1, []);
        gui.data.delta_S = reshape(gui.data.delta_S_init_f(selected), 1, []);
        storage = reshape(gui.data.storage_stiffness_init(selected), 1, []);
        loss = reshape(gui.data.loss_stiffness_init(selected), 1, []);
        valid = isfinite(storage) & storage > 0 & isfinite(loss) & loss >= 0 & ...
            isfinite(gui.data.h) & gui.data.h > 0;
        if ~any(valid(:))
            delete(gui.handles.h_waitbar);
            warndlg('No valid storage and loss stiffness measurements in the selected depth range.', ...
                'Viscoelastic data unavailable');
            return;
        end
        gui.data.S = storage .* 1e-6;
        gui.data.S(~valid) = NaN;
        guidata(gcf, gui);
    end
    
    %% Load-Displacement curve analysis
    if gui.variables.y_axis == 1
        model_load_disp;
        gui = guidata(gcf); guidata(gcf, gui);
        gui.results.P_fit = gui.results.P_fit./gui.data.loadFact;
        guidata(gcf, gui);
    end
    
    %% Stiffness analysis
    if gui.variables.y_axis == 2
        model_stiffness;
        gui = guidata(gcf); guidata(gcf, gui);
        gui.results.S_fit = gui.results.S_fit./gui.data.stifFact;
        guidata(gcf, gui);
    end
    
    %% Load over stiffness squared analysis
    if gui.variables.y_axis == 3
        model_loadOverstiffnessSquared;
        gui = guidata(gcf); guidata(gcf, gui);
        gui.results.LS2_fit = gui.results.LS2_fit .* (gui.data.stifFact.^2) ./ ...
            gui.data.loadFact;
        gui.results.delta_LS2 = ...
            ls2_incertitude(gui.data.P, gui.data.S, gui.results.LS2,...
            gui.data.delta_P, gui.data.delta_S);
        guidata(gcf, gui);
    end
    
    %% Calculations of function area (for all cases, needed of contact radius estimation)
    model_function_area;
    gui = guidata(gcf); guidata(gcf, gui);
    if viscoelastic
        valid = valid & isfinite(gui.results.Ac) & gui.results.Ac > 1e-9 & ...
            isfinite(gui.results.hc) & gui.results.hc > 1e-9;
        if ~any(valid(:))
            delete(gui.handles.h_waitbar);
            warndlg('No valid contact areas in the selected depth range.', ...
                'Viscoelastic data unavailable');
            return;
        end
        beta = beta_selection;
        gui = guidata(gcf);
        gui.results.storage_modulus = NaN(size(storage));
        gui.results.loss_modulus = NaN(size(storage));
        gui.results.loss_tangent = NaN(size(storage));
        [gui.results.storage_modulus(valid), gui.results.loss_modulus(valid), ...
            gui.results.loss_tangent(valid)] = viscoelastic_properties( ...
            storage(valid), loss(valid), gui.results.Ac(valid) .* 1e-18, beta);
        if any(~valid(:))
            warning('NIMS:Viscoelastic:InvalidSamples', ...
                'Excluded %d samples with invalid stiffness or contact area.', sum(~valid(:)));
        end
        guidata(gcf, gui);
    end
    
    %% Calculations of Young's modulus or Hardness
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        [gui.results.Eeff_red, gui.results.Esample_red, gui.results.Esample] = ...
            model_elastic(gui.data.S, gui.results.Ac, gui.data.nuf, gcf);
        gui.results.delta_E = ...
            elasticModulus_incertitude(gui.data.P, gui.data.h, gui.data.S, ...
            gui.results.hc, gui.results.Eeff_red, ...
            gui.data.delta_P, gui.data.delta_h, gui.data.delta_S);
        guidata(gcf, gui);
        %% Set model to use for calculations
        if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
            try
                if numel(gui.variables.elastic_models) > 1
                    model_compare_elastic(gui.variables.elastic_models);
                else
                    model_bilayer_elastic(gui.variables.val2);
                end
            catch exception
                delete(gui.handles.h_waitbar);
                rethrow(exception);
            end
        elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
            model_multilayer_elastic(gui.variables.val2);
        end
    elseif gui.variables.y_axis == 6
        gui.results.H = model_hardness(gui.data.P, gui.results.Ac);
        gui.results.delta_H = ...
            hardness_incertitude(gui.data.P, gui.data.h, gui.data.S, ...
            gui.results.hc, gui.results.H, ...
            gui.data.delta_P, gui.data.delta_h, gui.data.delta_S);
        guidata(gcf, gui);
        %% Set model to use for calculations
        if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
            model_bilayer_plastic(gui.variables.val2);
        elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
            model_multilayer_plastic(gui.variables.val2);
        end
        
    end
    
    if gui.variables.y_axis == 7 || gui.variables.y_axis == 8
        gui.data.hr = plasticDepth(gui.data.h, gui.data.P, gui.data.S);
        P = polyfit(gui.data.h,gui.data.hr,1);
        % y_linFit = P(1)*gui.data.h+P(2); % to plot the fit...
        gui.data.results.slopeDepth = P(1);
        [gui.results.Eeff_red, gui.results.Esample_red, gui.results.Esample] = ...
            model_elasticModulus_Guillonneau(gui.variables.val1, gui.data.P, ...
            gui.data.S, gui.data.results.slopeDepth, gui.data.indenter_tip_angle, ...
            1.5, gui.data.nuf, gcf, gui.config.numerics.alpha_Loubet);
        for ii = 1:1:length(gui.data.h)
            gui.results.Em_red(ii) = 0;
            gui.results.Hf(ii) = 0;
            gui.results.delta_E(ii) = 0;
            gui.results.delta_H(ii) = 0;
        end
    end
    
    if gui.variables.y_axis == 7
        guidata(gcf, gui);
    elseif gui.variables.y_axis == 8
        gui.results.H = model_hardness_Guillonneau(gui.data.P, gui.data.S, ...
            gui.results.Esample_red);
        guidata(gcf, gui);
    end
    
    % Be careful of the order of the 3 following lines, because gcf is
    % the waitbar during calculations !!!
    gui = guidata(gcf);
    delete(gui.handles.h_waitbar);
    guidata(gcf, gui);
    
    % Refactor data for plot
    gui.data.h = gui.data.h/gui.data.dispFact;
    gui.data.delta_h = gui.data.delta_h/gui.data.dispFact;
    gui.data.P = gui.data.P/gui.data.loadFact;
    gui.data.delta_P = gui.data.delta_P/gui.data.loadFact;
    gui.data.S = gui.data.S/gui.data.stifFact;
    gui.data.delta_S = gui.data.delta_S/gui.data.stifFact;
    
    guidata(gcf, gui);
    
    %% Plot data
    plot_exp_vs_mod_setvariables;
    gui = guidata(gcf); guidata(gcf, gui);
    
    plot_exp_vs_mod;
    if gui.variables.x_axis ~= 4 && gui.variables.val2 > 1 && ...
            numel(gui.variables.elastic_models) == 1
        rSquare = r_square(gui.axis.y2plot, gui.axis.y2plot_2);
        xl = xlim;
        yl = ylim;
        text(xl(2)-0.1*xl(2), yl(2)-0.05*yl(2), ['R²=',num2str(rSquare)]);
    end
    gui = guidata(gcf);
else
    warndlg(gui.flag.warnText, 'Input Error');
    delete(gui.handles.h_waitbar);
end

% Update date and clock
set(gui.handles.date_GUI, ...
    'String', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'));

guidata(gcf, gui);

end