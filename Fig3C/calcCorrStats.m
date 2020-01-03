% Author: QZ
% 07/11/2019
% calcCorrStats.m
function [dp_arr,c_arr,rTA_arr,rTS_arr,cTS_arr,tpr_arr,fpr_arr,lrr_arr,...
    lrc_arr] = calcCorrStats(twdb,ids,idxs)
% all params and returns except for twdb are arrays of numbers

dp_arr = zeros(1,length(idxs));
c_arr = zeros(1,length(idxs));
rTA_arr = zeros(1,length(idxs));
rTS_arr = zeros(1,length(idxs));
cTS_arr = zeros(1,length(idxs));
tpr_arr = zeros(1,length(idxs));
fpr_arr = zeros(1,length(idxs));
lrr_arr = zeros(1,length(idxs));
lrc_arr = zeros(1,length(idxs));
for i = 1:length(idxs)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone,~] = get_all_trials(twdb,ids(i),idxs(i));
    if isa(mouseTrials,'cell')
        mouseTrials = first(mouseTrials);
    end
    if isa(mouseFluorTrials,'cell')
        mouseFluorTrials = first(mouseFluorTrials);
    end
    [dp,rTA,rTS,cTS,c,tpr,fpr,lrr,lrc] = get_dprime_traceArea(mouseTrials,...
        mouseFluorTrials,rewardTone,costTone,1); % for now, all t=1
    dp_arr(i) = dp;
    c_arr(i) = c;
    rTA_arr(i) = rTA;
    rTS_arr(i) = rTS;
    cTS_arr(i) = cTS;
    tpr_arr(i) = tpr;
    fpr_arr(i) = fpr;
    lrr_arr(i) = lrr;
    lrc_arr(i) = lrc;
end
end