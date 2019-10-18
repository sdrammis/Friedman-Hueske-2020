% Author: QZ
% 07/11/2019
% calcCorrStats1.m
function [dp_arr,c_arr,rTA_arr,rTS_arr,cTS_arr,tpr_arr,fpr_arr,lrr_arr,...
    lrc_arr] = calcCorrStats1(twdb,id,idxs)
% all params and returns except for twdb and id are arrays of numbers
% id is mouse ID as cell
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
    disp(['~~~' num2str(i) ': ' num2str(idxs(i)) '~~~'])
    if isempty(twdb(idxs(i)).trialData) || isempty(twdb(idxs(i)).raw470Session)
        disp('Empty');
        dp_arr(i) = NaN;
        c_arr(i) = NaN;
        rTA_arr(i) = NaN;
        rTS_arr(i) = NaN;
        cTS_arr(i) = NaN;
        tpr_arr(i) = NaN;
        fpr_arr(i) = NaN;
        lrr_arr(i) = NaN;
        lrc_arr(i) = NaN;
    else
        disp('Ok')
        [mouseTrials,mouseFluorTrials,rewardTone,costTone,~] = get_all_trials(twdb,id,idxs(i));
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
end