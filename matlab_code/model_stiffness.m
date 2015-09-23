%% Copyright 2014 MERCIER David
function model_stiffness
%% Function used to analyze stiffness
gui = guidata(gcf);

%% Fit of the stiffness-displacement curve
if gui.variables.val2 == 2
    % See also 'fitlm' function in Matlab for linear regression
    polyCoeff = 1;
    [Pfit Sfit] = polyfit(gui.data.h, gui.data.S, polyCoeff);
    gui.results.S_fit = Pfit(1).*gui.data.h + Pfit(2); % in mN/nm
    gui.results.linear_fit = Pfit;
    gui.results.residual = gui.results.S_fit - gui.data.S;
    gui.results.rSquare = r_square(gui.data.S, gui.results.S_fit);
elseif gui.variables.val2 == 3
    polyCoeff = 2;
    [Pfit Sfit]  = polyfit(gui.data.h, gui.data.S, polyCoeff);
    gui.results.S_fit = Pfit(1).*(gui.data.h).^2 + ...
        Pfit(2).*(gui.data.h) + Pfit(3); % in mN/nm
    gui.results.linear_fit = Pfit;
    gui.results.residual = gui.results.S_fit - gui.data.S;
    gui.results.rSquare = r_square(gui.data.S, gui.results.S_fit);
else
    gui.results.linear_fit = [0 0 0];
    gui.results.S_fit = 0;
    gui.results.residual = 0;
    gui.results.rSquare = 0;
end

guidata(gcf, gui);

end