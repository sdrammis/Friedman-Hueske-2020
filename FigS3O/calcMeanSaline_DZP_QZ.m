function [tpr,fpr,c,dp,lrr,lrc,dzpTPR,dzpFPR,dzpC,dzpDP,dzpLRR,dzpLRC] = calcMeanSaline_DZP_QZ(table,mouseID,lickThreshold)
% mouseID: a cell array containing the mouseID e.g. {'4199'}
logArr = ismember([table.mouseID{:}],mouseID);
all_lrr = table.LRr(logArr);
all_lrc = table.LRc(logArr);
if lickThreshold == 1
    all_tpr = table.TPR1(logArr);
    all_fpr = table.FPR1(logArr);
    all_c = table.C1(logArr);
    all_dp = table.DP1(logArr);
elseif lickThreshold == 2
    all_tpr = table.TPR2(logArr);
    all_fpr = table.FPR2(logArr);
    all_c = table.C2(logArr);
    all_dp = table.DP2(logArr);
elseif lickThreshold == 3
    all_tpr = table.TPR3(logArr);
    all_fpr = table.FPR3(logArr);
    all_c = table.C3(logArr);
    all_dp = table.DP3(logArr);
end
tpr = nanmean([all_tpr(1),all_tpr(3)]);
fpr = nanmean([all_fpr(1),all_fpr(3)]);
c = nanmean([all_c(1),all_c(3)]);
dp = nanmean([all_dp(1),all_dp(3)]);
lrr = nanmean([all_lrr(1),all_lrr(3)]);
lrc = nanmean([all_lrc(1),all_lrc(3)]);
dzpTPR = all_tpr(2);
dzpFPR = all_fpr(2);
dzpC = all_c(2);
dzpDP = all_dp(2);
dzpLRR = all_lrr(2);
dzpLRC = all_lrc(2);
end