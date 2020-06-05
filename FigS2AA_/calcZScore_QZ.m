function [z,nanIdxs,zIdxs] = calcZScore_QZ(data)
% Author: QZ
% 08/13/2019
% calculates z-scores from an array of numerical values and returns an
% array of z-scores of finite values and indices of non-finite data values
mean = nanmean(data);
std = nanstd(data);
z = (data(isfinite(data))-mean)/std;
nanIdxs = find(~isfinite(data));
zIdxs = find(isfinite(data));
end