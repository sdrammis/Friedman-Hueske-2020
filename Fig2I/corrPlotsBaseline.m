% 07/10/2019
% Author: QZ
% corrPlotsBaseline.m
function [wtIdxs,c_WT,rTS_WT,hdIdxs,c_HD,rTS_HD] = corrPlotsBaseline(twdb,learn,age,striosomality)
% Part I. All Mice (07/10/2019-07/12/2019) session level
WT = mouseFilter(twdb,learn,age,'WT',striosomality,1); % ~~~~~~MODIFY~~~~~~
wtIdxs = zeros(1,length(WT));
for i = 1:length(WT)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,~] = getBaselineSessionNum_QZ(twdb,WT(i),1,3);
    wtIdxs(i) = twdbIdx;
end
wtAges = [twdb(wtIdxs).firstSessionAge];
[~,c_WT,~,rTS_WT,~,~,~,~,~] = calcCorrStats(twdb,WT,wtIdxs);

HD = mouseFilter(twdb,learn,age,'HD',striosomality,1); % ~~~~~~MODIFY~~~~~~
hdIdxs = zeros(1,length(HD));
for i = 1:length(HD)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,~] = getBaselineSessionNum_QZ(twdb,HD(i),1,3);
    hdIdxs(i) = twdbIdx;
end
hdAges = [twdb(hdIdxs).firstSessionAge];
[~,c_HD,~,rTS_HD,~,~,~,~,~] = calcCorrStats(twdb,HD,hdIdxs);
% plotting
% WT vs. HD
yLab = 'Reward Trace Area';
x1 = {c_WT,c_HD};
y = {rTS_WT,rTS_HD};
xLab1 = 'C';
ages = {wtAges,hdAges};
cases = {WT,HD};
% figure() WT vs. HD traces vs. C
nanIdxs = plotCorrROC3_QZ(x1,y,[striosomality ' WT and HD'],xLab1,yLab,1,{'WT','HD'},{'o','o'},...
    {{'b','b','b'},{'r','r','r'}},{'b','r'},1,ages,0,cases);
wtIdxs(nanIdxs{1}) = [];
c_WT(nanIdxs{1}) = [];
rTS_WT(nanIdxs{1}) = [];
hdIdxs(nanIdxs{2}) = [];
c_HD(nanIdxs{2}) = [];
rTS_HD(nanIdxs{2}) = [];
end