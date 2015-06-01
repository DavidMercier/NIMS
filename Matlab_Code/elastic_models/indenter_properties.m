%% Copyright 2014 MERCIER David
function [Eind, nuind, Eind_red] = indenter_properties(gcfValue, varargin)
%% Function to set indenter's properties (Young's modulus, Poisson's ratio)

if nargin == 0 || isempty(gcfValue)
    Eind = 1070;
    nuind = 0.07;
    Eind_red = reduced_YM(Eind, nuind^2);
    display(Eind_red);
    display(nuind);
    display(Eind);
else
    gui = guidata(gcfValue);
    % Young's modulus of of indenter material (in Pa)
    Eind = gui.data.indenter_material_ym * 10^9;
    gui.data.Eind = Eind;
    
    % Poisson's coefficient of indenter material
    nuind = gui.data.indenter_material_pr;
    gui.data.nuind = nuind;
    
    % Reduced Young's modulus of diamond.
    Eind_red = reduced_YM(Eind, nuind^2);
    gui.data.Eind_red = Eind_red;
    
    guidata(gcfValue, gui);
end

end