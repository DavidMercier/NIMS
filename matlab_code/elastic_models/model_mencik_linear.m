%% Copyright 2014 MERCIER David
function model_mencik_linear(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the linear model of Mencik et al. (1997)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Mencik''s linear model']);
end

x = gui.results.ac./gui.data.t;
x = checkValues(x);

% Ef_red_sol(1) = Ef_red
% Ef_red_sol(2) = Es_red
bilayer_model = @(Ef_red_sol, x) (Ef_red_sol(1) + ...
    (Ef_red_sol(2) - Ef_red_sol(1))*(x));

% Make a starting guess (Ef and Es in GPa)
gui.results.A0 = [gui.data.Ef_red, gui.data.Es_red];

if gui.config.licenceFlag
    [gui.results.Ef_red_sol_fit, ...
        gui.results.resnorm, ...
        gui.results.residual, ...
        gui.results.exitflag, ...
        gui.results.output, ...
        gui.results.lambda, ...
        gui.results.jacobian] =...
        minimizationProcess(bilayer_model, gui.results.A0, x, ...
        gui.results.Esample_red, ...
        [gui.config.numerics.Min_YoungModulus; 0], ...
        [gui.config.numerics.Max_YoungModulus; 1000], ...
        OPTIONS);
else
    model = @LMS;
    gui.results.Ef_red_sol_fit = fminsearch(model, gui.results.A0);
    warning('No Optimization toolbox available !');
end

    function [sse, FittedCurve] = LMS(params)
        Ef_red_sol(1) = params(1);
        Ef_red_sol(2) = params(2);
        FittedCurve = (Ef_red_sol(1) + ...
            (Ef_red_sol(2) - Ef_red_sol(1))*(x));
        ErrorVector = FittedCurve - gui.results.Esample_red;
        sse = sum(ErrorVector .^ 2);
    end

set(gui.handles.value_youngsub_GUI, ...
    'String', num2str(round(gui.results.Ef_red_sol_fit(2))));

gui.results.Em_red = (gui.results.Ef_red_sol_fit(1) + ...
    (gui.results.Ef_red_sol_fit(2) - gui.results.Ef_red_sol_fit(1))*(x));

gui.results.Ef_red(1:length(x)) = gui.results.Ef_red_sol_fit(1);
gui.results.Ef_red = gui.results.Ef_red';

guidata(gcf, gui);

end