%% Copyright 2014 MERCIER David
function emptyVariables
%% Function used to set empty variables

% Preallocation
gui.results.Ef     = NaN(length(gui.data.h), 1);
gui.results.Ef_red = NaN(length(gui.data.h), 1);
gui.results.Em_red = NaN(length(gui.data.h), 1);
gui.results.Hf = NaN(length(gui.data.h), 1);

for ii = 1:1:length(gui.data.h)
    gui.results.Ef(ii)      = 0;
    gui.results.Ef          = gui.results.Ef.';
    gui.results.Ef_red(ii)  = 0;
    gui.results.Ef_red      = gui.results.Ef_red.';
    gui.results.Ef_sol_fit  = 0;
    gui.results.Em_red(ii)  = 0;
    gui.results.Em_red      = gui.results.Em_red.';
    gui.results.Hf(ii) = 0;
    gui.results.Hf     = gui.results.Ef.';
end

end