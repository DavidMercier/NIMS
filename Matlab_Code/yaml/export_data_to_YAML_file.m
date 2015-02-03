%% Copyright 2014 MERCIER David
function export_data_to_YAML_file
%% Function used to export results of modelling in YAML file
% Visit the official YAML website : http://www.yaml.org/
% Get the code fot the YAML Matlab :  http://code.google.com/p/yamlmatlab/

gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Import data first','!!!');
    
else
    %% Store data in a structure
    if ismac
        gui.results.username = getenv('USER');
    else
        gui.results.username = getenv('USERNAME');
    end
    gui.results.date             = strcat(...
        datestr(datenum(clock), 'yyyy-mm-dd'), ...
        '_', datestr(datenum(clock), 'HH'), 'h-', ...
        datestr(datenum(clock), 'MM'), 'min-', ...
        datestr(datenum(clock), 'SS'), 's');
    gui.results.data_filename    = gui.data.filename_data;
    gui.results.data_pathname    = gui.data.pathname_data;
    gui.results.indenter         = gui.data.indenter_id_str;
    gui.results.min_max_depth_nm = [gui.data.min_depth, gui.data.max_depth];
    
    %% Get and save models and corrections setting
    list_val1 = get(gui.handles.value_modeldisp_GUI, 'String');
    num_val1  = get(gui.handles.value_modeldisp_GUI, 'Value');
    val1_str  = list_val1(num_val1, :);
    gui.results.model_elastic = val1_str;
    
    list_param_corr = get(gui.handles.popup_corr_King_GUI, 'String');
    num_param_corr  = get(gui.handles.popup_corr_King_GUI, 'Value');
    param1_corr_str = list_param_corr(num_param_corr, :);
    gui.results.correction_model_elastic = param1_corr_str;
    
    list_val2 = get(gui.handles.value_model_GUI, 'String');
    num_val2  = get(gui.handles.value_model_GUI, 'Value');
    val2_str  = list_val2(num_val2, :);
    gui.results.multi_bilayer_model_elastic = val2_str;
    
    if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
        param2_corr_model_str = 'Correction of the effective thickness applied. See in Mencik et al. (2003)';
        gui.results.correction_multi_bilayer_model_elastic = ...
            param2_corr_model_str;
    else
        param2_corr_model_str = 'No correction of the effective thickness';
        gui.results.correction_multi_bilayer_model_elastic = ...
            param2_corr_model_str;
    end
    
    if get(gui.handles.cb_CSM_corr_GUI, 'Value')==1
        gui.results.CSM_correction = 'CSM correction applied!!!';
    else
        gui.results.CSM_correction = 'No CSM correction';
    end
    
    %% Save results for the sample
    if isfield(gui.results, 'Esample_red')
        gui.results.mean_reduced_young_modulus_sample_GPa = ...
            mean(gui.results.Esample_red);
    end
    if isfield(gui.results, 'mean_hardness_sample_GPa')
        gui.results.mean_hardness_sample_GPa = ...
            round(mean(gui.results.H.*1000)./10)./100;
    end
    
    %% Save thin films and substrate properties & results
    if ~isfield(gui.results, 'Ef_sol_fit')
        gui.results.Ef_sol_fit = 'Not Calculated !';
    end
    if ~isfield(gui.results, 'Ef_sol')
        gui.results.Ef_sol = 'Not Calculated !';
    end
    
    if gui.variables.num_thinfilm == 1
        gui.results.Young_modulus_substrat_GPa   = str2double(get(gui.handles.value_youngsub_GUI, 'String'));
        gui.results.Poisson_coeff_substrat       = gui.data.nus;
        
    elseif gui.variables.num_thinfilm == 2
        gui.results.mean_Young_modulus_film0_GPa = gui.results.Ef_sol_fit;
        gui.results.fit_Young_modulus_film0_GPa  = gui.results.Ef_sol;
        gui.results.Poisson_coeff_film0          = gui.data.nuf0;
        gui.results.thickness_film0_nm           = gui.data.t0;
        
    elseif gui.variables.num_thinfilm == 3
        gui.results.Young_modulus_film0_GPa      = str2double(get(gui.handles.value_youngfilm0_GUI, 'String'));
        gui.results.Poisson_coeff_film0          = gui.data.nuf0;
        gui.results.thickness_film0_nm           = gui.data.t0;
        gui.results.mean_Young_modulus_film1_GPa = gui.results.Ef_sol_fit;
        gui.results.fit_Young_modulus_film1_GPa  = gui.results.Ef_sol;
        gui.results.Poisson_coeff_film1          = gui.data.nuf1;
        gui.results.thickness_film1_nm           = gui.data.t1;
        
    elseif gui.variables.num_thinfilm == 4
        gui.results.Young_modulus_film0_GPa      = str2double(get(gui.handles.value_youngfilm0_GUI, 'String'));
        gui.results.Poisson_coeff_film0          = gui.data.nuf0;
        gui.results.thickness_film0_nm           = gui.data.t0;
        gui.results.Young_modulus_film1_GPa      = str2double (get(gui.handles.value_youngfilm1_GUI, 'String'));
        gui.results.Poisson_coeff_film1          = gui.data.nuf1;
        gui.results.thickness_film1_nm           = gui.data.t1;
        gui.results.mean_Young_modulus_film2_GPa = gui.results.Ef_sol_fit;
        gui.results.fit_Young_modulus_film2_GPa  = gui.results.Ef_sol;
        gui.results.Poisson_coeff_film2          = gui.data.nuf2;
        gui.results.thickness_film2_nm           = gui.data.t2;
        
    end
    
    %% Write data in a YAML file
    list_val2 = get(gui.handles.value_model_GUI, 'String');
    num_val2  = get(gui.handles.value_model_GUI, 'Value');
    val2_str  = list_val2(num_val2,  :);
    yaml_result_title = strcat(gui.results.data_filename, '_', val2_str, '.yaml');
    
    WriteYaml(char(yaml_result_title), gui.results);
    movefile(char(yaml_result_title), gui.results.data_pathname);
    
    save_figure(gui.results.data_pathname, ...
        gui.handles.AxisPlot_GUI, yaml_result_title);
    
    helpdlg('Data and picture saved !', 'OK');
    
end

guidata(gcf, gui);

end