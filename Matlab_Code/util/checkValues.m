%% Copyright 2014 MERCIER David
function x = checkValues(x)

x(isinf(x)) = 0;
x(isnan(x)) = 0;
x(x < 0) = 0;

end