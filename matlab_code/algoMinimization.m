%% Copyright 2014 MERCIER David
function OPTIONS = algoMinimization
%% Function used to set the algorithm of minimization
gui = guidata(gcf);

if gui.config.licenceOpt_Flag
    if gui.config.matlab_year < 2014
        % http://nl.mathworks.com/help/optim/ug/optimization-options-reference.html
        OPTIONS = optimset('lsqcurvefit');
        OPTIONS = optimset(OPTIONS, 'TolFun',  gui.config.numerics.TolFun_value);
        OPTIONS = optimset(OPTIONS, 'TolX',    gui.config.numerics.TolX_value);
        OPTIONS = optimset(OPTIONS, 'MaxIter', gui.config.numerics.MaxIter_value);
    else
        OPTIONS = optimoptions('lsqcurvefit');
        OPTIONS = optimoptions(OPTIONS, 'TolFun',  gui.config.numerics.TolFun_value);
        OPTIONS = optimoptions(OPTIONS, 'TolX',    gui.config.numerics.TolX_value);
        OPTIONS = optimoptions(OPTIONS, 'MaxIter', gui.config.numerics.MaxIter_value);
    end
else
    % http://nl.mathworks.com/help/matlab/ref/optimset.html
    % http://nl.mathworks.com/help/matlab/optimization.html
    OPTIONS = struct();
end

end