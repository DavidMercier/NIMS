%% Copyright 2014 MERCIER David
function emptyVariables
%% Function used to set empty variables

g = guidata(gcf);

% Preallocation
g.results.Ef     = NaN(length(g.data.h), 1);
g.results.Ef_red = NaN(length(g.data.h), 1);
g.results.Em_red = NaN(length(g.data.h), 1);
g.results.Hf = NaN(length(g.data.h), 1);

for ii = 1:1:length(g.data.h)
    g.results.Ef(ii)      = 0;
    g.results.Ef          = g.results.Ef.';
    g.results.Ef_red(ii)  = 0;
    g.results.Ef_red      = g.results.Ef_red.';
    g.results.Ef_sol_fit  = 0;
    g.results.Em_red(ii)  = 0;
    g.results.Em_red      = g.results.Em_red.';
    g.results.Hf(ii) = 0;
    g.results.Hf     = g.results.Ef.';
end

guidata(gcf, g);

end