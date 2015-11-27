%% Copyright 2014 MERCIER David
function model_gao(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Gao et al. (1992) (for flat cylindrical indentation test...)
% see also Hay et al. (2011)
% Errors for phigao0 in Fischer-Cripps "Nanoindentation 2nd Ed.".

gui = guidata(gcf);

x = gui.results.t_corr./gui.results.ac;
x = checkValues(x);

gui.data.phigao1 = phi_gao_1(x);

% Poisson's coefficient of the composite (film + substrate)
gui.data.nuc = composite_poissons_ratio(gui.data.nus, gui.data.nuf, ...
    gui.data.phigao1);

gui.data.phigao0 = phi_gao_0(x, gui.data.nuc);

bilayer_model = @(Ef_red_sol, x) ...
    (1e-9*((((1e9*Ef_red_sol)-gui.data.Es_red) .* ...
    gui.data.phigao0)+gui.data.Es_red));

% Make a starting guess
gui.results.A0 = gui.data.Ef_red;

resultToolbox = isToolboxAvailable('Optimization Toolbox');

if resultToolbox
    [gui.results.Ef_red_sol_fit, ...
        gui.results.resnorm, ...
        gui.results.residual, ...
        gui.results.exitflag, ...
        gui.results.output, ...
        gui.results.lambda, ...
        gui.results.jacobian] =...
        minimizationProcess(bilayer_model, gui.results.A0, x, ...
        gui.results.Esample_red, ...
        gui.config.numerics.Min_YoungModulus, ...
        gui.config.numerics.Max_YoungModulus, ...
        OPTIONS);
else
    model = @LMS;
    gui.results.Ef_red_sol_fit = fminsearch(model, gui.results.A0);
    warning('No Optimization toolbox availble !');
end

    function [sse, FittedCurve] = LMS(params)
        Ef_red_sol(1) = params(1);
        FittedCurve = (1e-9*((((1e9*Ef_red_sol)-gui.data.Es_red) .* ...
            gui.data.phigao0)+gui.data.Es_red));
        ErrorVector = FittedCurve - gui.results.Esample_red;
        sse = sum(ErrorVector .^ 2);
    end

gui.results.Em_red = 1e-9 * ...
    ((((1e9*gui.results.Ef_red_sol_fit) - gui.data.Es_red) .* ...
    gui.data.phigao0) + gui.data.Es_red);

gui.results.Ef_red = 1e-9 * ...
    ((((1e9.*gui.results.Esample_red)-gui.data.Es_red) ./ ...
    gui.data.phigao0) + gui.data.Es_red);

guidata(gcf, gui);

end