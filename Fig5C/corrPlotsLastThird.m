% 07/12/2019
% Author: QZ
% corrPlotsLastThird.m
%% Part I. All Mice (07/12/2019) session level
WT = mouseFilter(twdb,'all','all','WT','all',1);
wtIdxs = zeros(1,length(WT));
wtLastThirdArrs = cell(1,length(WT));
for i = 1:length(WT)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,twdbIdxLastThird] = getBaselineSessionNum_QZ(twdb,WT(i),1,3);
    wtIdxs(i) = twdbIdx;
    wtLastThirdArrs{i} = twdbIdxLastThird;
end
wtAges = [twdb(wtIdxs).firstSessionAge];
[~,c_WT,rTA_WT,rTS_WT,cTS_WT,~,~,~,~] = calcCorrStatsMult(twdb,...
    WT,wtLastThirdArrs);

HD = mouseFilter(twdb,'all','all','HD','all',1);
hdIdxs = zeros(1,length(HD));
hdLastThirdArrs = cell(1,length(HD));
for i = 1:length(HD)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,twdbIdxLastThird] = getBaselineSessionNum_QZ(twdb,HD(i),1,3);
    hdIdxs(i) = twdbIdx;
    hdLastThirdArrs{i} = twdbIdxLastThird;
end
hdAges = [twdb(hdIdxs).firstSessionAge];
[~,c_HD,rTA_HD,rTS_HD,cTS_HD,~,~,~,~] = calcCorrStatsMult(twdb,...
    HD,hdLastThirdArrs);
% plotting
% WT vs. HD
yLab = {'R-C Trace Area','R+C Trace Area','Reward Trace Area','Cost Trace Area'};
x1 = {c_WT,c_HD};
y1 = {{rTA_WT,rTA_HD},{(rTS_WT+cTS_WT),(rTS_HD+cTS_HD)},{rTS_WT,cTS_HD},...
    {cTS_WT,cTS_HD}};
xLab1 = {'C','C','C','C'};
ages = {wtAges,hdAges};
cases = {WT,HD};
% figure() WT vs. HD traces vs. C
nanIdxs = plotCorrROC3_QZ(x1,y1,'WT and HD',xLab1,yLab,1,{'WT','HD'},{'*','o'},...
    {{'g','c','b'},{'m','r','k'}},{'b','r'},1,ages,0,cases);

%% Get more data
yngWTIdxs = setdiff(find(wtAges <= 8),nanIdxs{1});
midWTIdxs = setdiff(intersect(find(wtAges>=9),find(wtAges<=12)),nanIdxs{1});
oldWTIdxs = setdiff(find(wtAges >= 13),nanIdxs{1});

c_yngWT = c_WT(yngWTIdxs);
c_midWT = c_WT(midWTIdxs);
c_oldWT = c_WT(oldWTIdxs);
rTA_yngWT = rTA_WT(yngWTIdxs);
rTA_midWT = rTA_WT(midWTIdxs);
rTA_oldWT = rTA_WT(oldWTIdxs);
rTS_yngWT = rTS_WT(yngWTIdxs);
rTS_midWT = rTS_WT(midWTIdxs);
rTS_oldWT = rTS_WT(oldWTIdxs);
cTS_yngWT = cTS_WT(yngWTIdxs);
cTS_midWT = cTS_WT(midWTIdxs);
cTS_oldWT = cTS_WT(oldWTIdxs);

yngHDIdxs = setdiff(find(hdAges <= 8),nanIdxs{2});
midHDIdxs = setdiff(intersect(find(hdAges>=9),find(hdAges<=12)),nanIdxs{2});
oldHDIdxs = setdiff(find(hdAges >= 13),nanIdxs{2});

c_yngHD = c_HD(yngHDIdxs);
c_midHD = c_HD(midHDIdxs);
c_oldHD = c_HD(oldHDIdxs);
rTA_yngHD = rTA_HD(yngHDIdxs);
rTA_midHD = rTA_HD(midHDIdxs);
rTA_oldHD = rTA_HD(oldHDIdxs);
rTS_yngHD = rTS_HD(yngHDIdxs);
rTS_midHD = rTS_HD(midHDIdxs);
rTS_oldHD = rTS_HD(oldHDIdxs);
cTS_yngHD = cTS_HD(yngHDIdxs);
cTS_midHD = cTS_HD(midHDIdxs);
cTS_oldHD = cTS_HD(oldHDIdxs);
%% Figure 1 - WT vs. HD
figure();
hold on;
plotNoBar({c_yngWT,c_midWT,c_oldWT,},'',...
    {'<=8 months','9-12 months','>=13 months'},'','c','b','b',true);
hold on;
plotNoBar({c_yngHD,c_midHD,c_oldHD},'C',...
    {'<=8 months','9-12 months','>=13 months'},'C, WT vs. HD','m',...
    'r','r',true);
hold off;
legend('WT Young','WT Mid','WT Old','WT','HD Young','HD Mid','HD Old',...
    'HD','Location','BestOutside');
hold off;
%% Calculate Statistics
disp('------C Across Age------');
% WT
ttest2_QZ(c_yngWT,c_midWT,'Young-Mid WT: ');
ttest2_QZ(c_yngWT,c_oldWT,'Young-Old WT: ');
ttest2_QZ(c_midWT,c_oldWT,'Mid-Old WT: ');
% HD
ttest2_QZ(c_yngHD,c_midHD,'Young-Mid HD: ');
ttest2_QZ(c_yngHD,c_oldHD,'Young-Old HD: ');
ttest2_QZ(c_midHD,c_oldHD,'Mid-Old HD: ');

disp('------C Across Genotypes------');
ttest2_QZ(c_yngHD,c_yngWT,'Young HD-WT: ');
ttest2_QZ(c_midHD,c_midWT,'Mid HD-WT: ');
ttest2_QZ(c_oldHD,c_oldWT,'Old HD-WT: ');

disp('------One-Way ANOVA------');
cYWT = cell(1,length(yngWTIdxs));
cYWT(:) = {'Young WT'};
cMWT = cell(1,length(midWTIdxs));
cMWT(:) = {'Mid WT'};
cOWT = cell(1,length(oldWTIdxs));
cOWT(:) = {'Old WT'};
cYHD = cell(1,length(yngHDIdxs));
cYHD(:) = {'Young HD'};
cMHD = cell(1,length(midHDIdxs));
cMHD(:) = {'Mid HD'};
cOHD = cell(1,length(oldHDIdxs));
cOHD(:) = {'Old HD'};
groups = horzcat(cYWT,cMWT,cOWT,cYHD,cMHD,cOHD);
values = [c_yngWT,c_midWT,c_oldWT,c_yngHD,c_midHD,c_oldHD];
[p,tab,stats] = anova1(values,groups);
disp(['Significance: ' num2str(p)]);