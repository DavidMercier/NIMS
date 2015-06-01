%% Copyright 2014 MERCIER David
function CSM_correction
%% Function used to correct experimental data from CSM effects ("jack-hammering")
% CSM = Continuous Stiffness Measurement
% CSM correction from Pharr et al . (2009), only valid for Berkovich indenter !!!
% Vachhani et al. (2013) model is used for spherical indenters.
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Import data first !','!!!');
    
else
    list_indenters = get(gui.handles.value_indentertype_GUI, 'String');
    num_indenters  = get(gui.handles.value_indentertype_GUI, 'Value');
    indenter_id    = list_indenters(num_indenters, :);
    
    for ii = 1:1:length(gui.config.indenter.Indenter_IDs)
        func_area_fields = getfield(gui.config.indenter,{1}, indenter_id{':'},{':'});
        gui.config.func_area = cell2mat(func_area_fields(:));
        
        if strcmp(indenter_id, gui.config.indenter.Indenter_IDs(ii)) == 1
            [indenter_id_str] = indenter_id{:};
            
            if strcmp(indenter_id_str(1:4), 'Berk') == 1 && ...
                    (get(gui.handles.cb_CSM_corr_GUI, 'Value')) == 1
                
                % Constants given by Pharr et al. (2009)
                K_Pharr = gui.config.numerics.CSM_K_Pharr;
                m_Pharr = gui.config.numerics.CSM_m_Pharr;
                
                gui.data.h_CSM_Corr = gui.data.h + ((2^0.5).*gui.data.delta_h);
                gui.data.P_CSM_Corr = gui.data.P + ((2^0.5).*gui.data.delta_P);
                gui.data.S_CSM_Corr = ((1/((2*pi)^0.5)) .* ...
                    ((1/K_Pharr).^(1/m_Pharr))) .*...
                    (1-(1-(((2*(2.^0.5).*gui.data.delta_h.*gui.data.S) ./ ...
                    (max(gui.data.P))))).^(1/m_Pharr)) .* ...
                    (max(gui.data.P)./gui.data.delta_h);
                
                gui.data.h = gui.data.h_CSM_Corr;
                gui.data.P = gui.data.P_CSM_Corr;
                gui.data.S = gui.data.S_CSM_Corr;
                
                if abs(imag(gui.data.S))>0 % Wrong inputs or wrong units !
                    gui.flag.flagCSM = 0;
                    commandwindow;
                    display('Wrong inputs or wrong units !');
                else
                    gui.flag.flagCSM = 1;
                end
            else
                gui.flag.flagCSM = 0;
            end
        end
    end
    
end

if gui.flag.flagCSM == 0
    gui.data.h = gui.data.h_final.';
    gui.data.delta_h = gui.data.delta_h_final.'; % in nm
    
    gui.data.P = gui.data.P_final.';
    gui.data.delta_P = gui.data.delta_P_final.'; % in mN
    
    gui.data.S = gui.data.S_final.';
    gui.data.delta_S = gui.data.delta_S_final.'; % in mN/nm
end


guidata(gcf, gui);

end