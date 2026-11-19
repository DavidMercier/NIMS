%% Copyright 2014 MERCIER David
function [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
    minimizationProcess(FUN,X0,XDATA,YDATA,LB,UB,OPTIONS)
%% Function used to process the minimization

[X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = lsqcurvefit(...
    FUN,X0,XDATA,YDATA,LB,UB,OPTIONS);

end

