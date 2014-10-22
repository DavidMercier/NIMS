%% Copyright 2014 MERCIER David
function model_elastic_set
%% Function used to set the properties of the top film
gui = guidata(gcf);

if get(gui.handles.value_numthinfilm_GUI, 'Value') == 1
    gui.data.nuf = gui.data.nus;
    gui.data.t = 0;
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
    gui.data.nuf = gui.data.nuf0;
    gui.data.t = gui.data.t0;
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3
    gui.data.nuf = gui.data.nuf1;
    gui.data.t = gui.data.t1;
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
    gui.data.nuf = gui.data.nuf2;
    gui.data.t = gui.data.t2;
    
end

guidata(gcf, gui);

end