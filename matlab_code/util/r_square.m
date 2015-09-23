%% Copyright 2014 MERCIER David
function rSquare = r_square(rawData, fitData, varargin)
%% Function used to calculate the r square value of a fit

if nargin == 0
    % Example from Matlab
    load accidents;
    x = hwydata(:,14); % Population of states
    y = hwydata(:,4); % Accidents per state
    b1 = x\y;
    yCalc1 = b1*x;
    
    figure;
    scatter(x,y);
    hold on;
    
    plot(x,yCalc1);
    xlabel('Population of state');
    ylabel('Fatal traffic accidents per state');
    title('Linear Regression Relation Between Accidents & Population');
    grid on;
    
    rSquare = r_square(y, yCalc1);
    return
end

meanRawData = mean(rawData);

SStot1 = zeros(1,length(rawData));
for ii = 1:length(rawData)
    SStot1(ii) = (rawData(ii) - meanRawData).^2;
end
SStot2 = sum(SStot1);

SSres1 = zeros(1,length(rawData));
for ii = 1:length(rawData)
    SSres1(ii) = (rawData(ii) - fitData(ii)).^2;
end
SSres2 = sum(SSres1);

rSquare = round(1e4*(1 - (SSres2/ SStot2)))/1e4;

end