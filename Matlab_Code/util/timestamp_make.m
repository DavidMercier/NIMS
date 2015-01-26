%% Copyright 2014 MERCIER David
function ts = timestamp_make(the_time)
%% Function used to get date and time as a string
% the_time: time to display

% See also function 'datetime.m' in Matlab R2014b

if nargin == 0;
    the_time = now;
end

[y, m, d, h, mn, s] = datevec(the_time);
time_str = sprintf('%02ih%02im%02is',h,mn,round(s));
ts = [datestr(the_time, 'yyyy-mm-dd'), '_', time_str];

end