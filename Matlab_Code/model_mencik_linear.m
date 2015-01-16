%% Copyright 2014 MERCIER David
function model_mencik_linear
%% Function used to calculate Young's modulus in bilayer system with the linear model of Mencik et al. (1997)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Mencik''s linear model']);
end

x = gui.results.ac./gui.data.t;

% Ef_red_sol(2) = gui.data.Es_red
bilayer_model = @(Ef_red_sol, x) (Ef_red_sol(1) + ...
    (Ef_red_sol(2) - Ef_red_sol(1))*(x));

% Make a starting guess (Ef and Es in GPa)
gui.results.Ef_red_sol0 = [...
    str2double(get(gui.handles.value_youngfilm1_GUI, 'String'))/(1-gui.data.nuf.^2); ...
    gui.data.Es_red];

OPTIONS = optimset('lsqcurvefit');
OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
[gui.results.Ef_red_solfit, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    lsqcurvefit(bilayer_model, gui.results.Ef_red_sol0, x, ...
    gui.results.Esample_red, [0;0], [1000;1000], OPTIONS);

gui.results.Ef_sol_fit(1) = gui.results.Ef_red_solfit(1) * ...
    (1-gui.data.nuf^2);

gui.results.Ef_sol_fit(2) = gui.results.Ef_red_solfit(2) * ...
    (1-gui.data.nus^2);

set(gui.handles.value_youngsub_GUI, ...
    'String', num2str(round(gui.results.Ef_sol_fit(2))));

gui.results.Em_red = (gui.results.Ef_red_solfit(1) + ...
    (gui.results.Ef_red_solfit(2) - gui.results.Ef_red_solfit(1))*(x));

gui.results.Ef_red(1:length(x)) = gui.results.Ef_red_solfit(1);
gui.results.Ef_red = gui.results.Ef_red';

guidata(gcf, gui);

end