Minimization process
=======================

.. include:: includes.rst

Least mean squares
###############################

Experimental curves are fitted with models using the least mean squares method.
The method of least squares is a standard approach in regression analysis band is
based on the resolution of the following problem, by finding the coefficients :math:`x` :

    .. math:: blabla
            :label: lsqcurvefit

- `Matlab Optimization toolbox. <http://nl.mathworks.com/help/optim/index.html>`_

- `Least squares method. <https://en.wikipedia.org/wiki/Least_squares>`_

- `Curve fitting. <https://en.wikipedia.org/wiki/Curve_fitting>`_

- `Mathematical optimization." (2002). <https://en.wikipedia.org/wiki/Mathematical_optimization>`_

Residuals
###########

The residuals from a fitted model are the differences between the response data and the corresponding prediction of the response computed using the regression function.
Mathematically, the definition of the residual for the ith observation in the data set is written :

    .. math:: r_\text{i} = y_\text{i} − f(\hat{y}_\text{i})
            :label: residuals

with :math:`y_\text{i}` denoting the ith response value and :math:`\hat{y}_\text{i}` the predicted response value.

If the model fits the data correctly, the residuals approximate the random errors.

- `Matlab residual analysis. <http://nl.mathworks.com/help/curvefit/residual-analysis.html>`_

- `Error and residuals. <https://en.wikipedia.org/wiki/Errors_and_residuals>`_
