function SE = calcSE(dataArray)
% Author: QZ
% 06/11/2019
% Calculates standard error, given an array of numbers
SE = nanstd(dataArray)/sqrt(sum(isfinite(dataArray)));
end