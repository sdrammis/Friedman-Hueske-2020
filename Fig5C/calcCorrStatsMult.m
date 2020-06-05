% Author: QZ
% 07/12/2019
% calcCorrStatsMult.m
function [dp_arr,c_arr,rTA_arr,rTS_arr,cTS_arr,tpr_arr,fpr_arr,lrr_arr,...
    lrc_arr] = calcCorrStatsMult(twdb,ids,idxs)
% all params and returns except for twdb and id are arrays of numbers
% ids :: {...} length n
% idxs :: {[start1:end1],[start2:end2],...} length n
dp_arr = zeros(1,length(ids));
c_arr = zeros(1,length(ids));
rTA_arr = zeros(1,length(ids));
rTS_arr = zeros(1,length(ids));
cTS_arr = zeros(1,length(ids));
tpr_arr = zeros(1,length(ids));
fpr_arr = zeros(1,length(ids));
lrr_arr = zeros(1,length(ids));
lrc_arr = zeros(1,length(ids));
for i = 1:length(ids)
    disp(['------' num2str(i) ': ' ids{i} '------']);
    disp('calcCorrStats1')
    [dp,c,rTA,rTS,cTS,tpr,fpr,lrr,lrc] = calcCorrStats1(twdb,ids(i),idxs{i});
    dp_arr(i) = nanmean(dp);
    c_arr(i) = nanmean(c);
    rTA_arr(i) = nanmean(rTA);
    rTS_arr(i) = nanmean(rTS);
    cTS_arr(i) = nanmean(cTS);
    tpr_arr(i) = nanmean(tpr);
    fpr_arr(i) = nanmean(fpr);
    lrr_arr(i) = nanmean(lrr);
    lrc_arr(i) = nanmean(lrc);
end
end