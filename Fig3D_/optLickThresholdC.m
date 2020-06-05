%% Determining best lick threshold for each DZP mouse
% Author: QZ
% 06/20/2019
% optLickThreshold.m
function [absMaxVals,thresholds,logArr1_2,logArr1,logArr1_3] = optLickThresholdC(conc,dzp)
% index is actually lick threshold!
%% Load data
% dzp1 = load('dzp_conc_1.mat');
% dzp1 = dzp1.dzp1;
% dzp2 = load('dzp_conc_0point5.mat');
% dzp2 = dzp2.dzp2;
% dzp3 = load('dzp_conc_0point35.mat');
% dzp3 = dzp3.dzp3;
%% Find best lick threshold for each mouse! DZP1
% best lick threshold yields greatest difference between dzp and average of
% before and after saline trials (for c)
% cThreshold = zeros(1,height(dzp1));
% if conc == 1
%     dzp = dzp1;
% elseif conc == 0.5
%     dzp = dzp2;
% end
dT1 = {strcmp(dzp.sessionType,'Diazepam')};
logArr1 = dT1{1};
c1 = dzp.C1(logArr1)';
c2 = dzp.C2(logArr1)';
c3 = dzp.C3(logArr1)';
sB1 = {strcmp(dzp.sessionType,'Saline Before')};
logArr1_2 = sB1{1};
c1_2 = dzp.C1(logArr1_2)';
c2_2 = dzp.C2(logArr1_2)';
c3_2 = dzp.C3(logArr1_2)';
sA1 = {strcmp(dzp.sessionType,'Saline After')};
logArr1_3 = sA1{1};
c1_3 = dzp.C1(logArr1_3)';
c2_3 = dzp.C2(logArr1_3)';
c3_3 = dzp.C3(logArr1_3)';
s1 = [c1_2;c1_3];
mS1 = nanmean(s1);
s2 = [c2_2;c2_3];
mS2 = nanmean(s2);
s3 = [c3_2;c3_3];
mS3 = nanmean(s3);
% get greatest difference between mSi,dpi
diff1 = c1-mS1;
diff2 = c2-mS2;
diff3 = c3-mS3;
allDiffs = [diff1;diff2;diff3];
[~,thresholds] = max(abs(allDiffs));
absMaxVals = allDiffs(sub2ind(size(allDiffs),thresholds,1:size(allDiffs,2)));
% for i = 1:length(thresholds)
%     for j = (3*i-2):(3*i)
%         cThreshold(j) = thresholds(i);
%     end
% end
% disp('C thresholds conc 1 mg/kg');
% disp(absMaxVals);
% disp(index);
end