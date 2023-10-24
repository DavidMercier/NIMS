Minimization process
=======================

.. include:: includes.rst

Least mean squares
###############################

Experimental curves are fitted with models using the least mean squares method.
The method of least squares is a standard approach in regression analysis band is
based on the resolution of the following problem, by finding the coefficients :math:`x` :

    .. math:: \underset{x}{\mathrm{min}} \| F(x,xdata)−ydata \|_2^2 = \underset{x}{\mathrm{min}} \sum_{\substack{i}} (F(x,xdata_\text{i})−ydata_\text{i})^2
            :label: lsqcurvefit
            
With given input data :math:`xdata` and the observed output :math:`ydata`.

- `Matlab Optimization toolbox. <http://nl.mathworks.com/help/optim/index.html>`_

- `Matlab nonlinear curve-fitting. <http://nl.mathworks.com/help/optim/ug/lsqcurvefit.html?searchHighlight=lsqcurvefit>`_

- `Least squares method. <https://en.wikipedia.org/wiki/Least_squares>`_

- `Curve fitting. <https://en.wikipedia.org/wiki/Curve_fitting>`_

- `Mathematical optimization. <https://en.wikipedia.org/wiki/Mathematical_optimization>`_

Fischer-Cripps A.C. wrote a detailed section about the non-linear least squares fitting in his book "Nanoindentation" (pp. 253-256) [#Fischer-Cripps_2011]_.

.. [#Fischer-Cripps_2011] `Fischer-Cripps A.C., "Nanoindentation" Springer 3rd Ed. (2011). <https://doi.org/10.1007/978-1-4419-9872-9>`_

Residuals
###########

The residuals from a fitted model are the differences between the response data and the corresponding prediction of the response computed using the regression function.
Mathematically, the definition of the residual for the ith observation in the data set is written :

    .. math:: r_\text{i} = y_\text{i} − \hat{y}_\text{i}
            :label: residuals

With :math:`y_\text{i}` denoting the ith response value and :math:`\hat{y}_\text{i}` the ith predicted response value.

If the model fits the data correctly, the residuals approximate the random errors.

- `Matlab residual analysis. <http://nl.mathworks.com/help/curvefit/residual-analysis.html>`_

- `Error and residuals. <https://en.wikipedia.org/wiki/Errors_and_residuals>`_

- `How can I tell if a model fits my data? <http://www.itl.nist.gov/div898/handbook/pmd/section4/pmd44.htm#resdef>`_
