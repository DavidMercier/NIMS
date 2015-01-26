%% Copyright 2014 MERCIER David
function screenshots
%% Function used to generate sequential screenshots of the GUI running with given files.

% Initialization of parameters
SCREENSHOT = strcat(timestamp_make, 'screenshots');
SCREENSHOT_DIR = ??;
SCRSHOT_NUM = 1;

% Run the GUI
GUI_Extraction_EP_properties_for_multilayer_sample;
gui = guidata(gcf);

% Optimized geometry and visualization
SCRSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCRSHOT_NUM);

end