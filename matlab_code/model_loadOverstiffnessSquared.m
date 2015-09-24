%% Copyright 2014 MERCIER David
function model_loadOverstiffnessSquared
%% Function used to analyze load over stiffness squared
gui = guidata(gcf);

%% Fit of the (load over stiffness squared)-displacement curve
if gui.variables.val2 == 2
    % See also 'fitlm' function in Matlab for linear regression
    polyCoeff = 1;
    [Pfit Sfit] = polyfit(gui.data.h, (gui.data.P ./ (gui.data.S.^2)), polyCoeff);
    gui.results.LS2_fit = Pfit(1).*gui.data.h + Pfit(2); % in mN/nm
    gui.results.linear_fit = Pfit;
    gui.results.residual = gui.results.LS2_fit - (gui.data.P ./ (gui.data.S.^2));
    gui.results.rSquare = r_square((gui.data.P ./ (gui.data.S.^2)), ...
        gui.results.LS2_fit);
else
    gui.results.linear_fit = [0 0 0];
    gui.results.LS2_fit = 0;
    gui.results.residual = 0;
    gui.results.rSquare = 0;
end

guidata(gcf, gui);

end