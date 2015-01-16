%% Copyright 2014 MERCIER David
function model_mencik_reciprocal_exponential
%% Function used to calculate Young's modulus in bilayer system with
% the reciprocal exponential model of Mencik et al. (1997)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Mencik''s reciprocal exponential model']);
end

x = gui.results.ac./gui.data.t;

% A(1) = ln(1/Ef-1/Es)
% A(2) = -alpha
bilayer_model = @(A, x) (A(1) + A(2)*x);

% Make a starting guess
gui.results.A0 = [...
    str2double(get(gui.handles.value_youngfilm1_GUI, 'String')) / ...
    (1-gui.data.nuf.^2); -20];

OPTIONS = optimset('lsqcurvefit');
OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
[gui.results.A, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    lsqcurvefit(bilayer_model, gui.results.A0, x, ...
    log(abs((1./gui.results.Esample_red) - (1./(gui.data.Es_red*1e-9)))), ...
    [-100;-100], [100;100], OPTIONS);

if sum(gui.results.Esample_red - gui.data.Es_red*1e-9) > 0
    k = 1;
else
    k = -1;
end

% FIXME: k is not used because it gives wrong results !!!
% gui.results.Ef_red_solfit(1) = 1/((1/(gui.data.Es_red*1e-9)) + k *...
%     exp(gui.results.A(1)));

gui.results.Ef_red_solfit(1) = 1/((1/(gui.data.Es_red*1e-9)) + ...
    exp(gui.results.A(1)));

gui.results.Ef_sol_fit(1) = gui.results.Ef_red_solfit(1) * ...
    (1-gui.data.nuf^2);

gui.results.Ef_sol_fit(2) = gui.results.A(2);

gui.results.Em_red = (1/(gui.data.Es_red*1e-9) + ...
    (((1/gui.results.Ef_red_solfit(1)) - (1/(gui.data.Es_red*1e-9))) .* ...
    exp(gui.results.A(2) .* x))).^-1;

gui.results.Ef_red(1:length(x)) = gui.results.Ef_red_solfit(1);
gui.results.Ef_red = gui.results.Ef_red';

guidata(gcf, gui);

end