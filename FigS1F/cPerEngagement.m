function cPerEngagement(twdb)

%% ROC Graphs - Engagement
% Author: QZ
% 06/14/2019
% roc_graphs2_4.m
%% loads data
%% Apply filters
% createStruct(twdb,age,health,learned,engagementFilt,photoFilt,cStats)
learningEngaged = createStruct(twdb,'all','all',true,true,false,false);
mouseIDs = {learningEngaged(:).ID};
%% Calculate y data
% C overall before
% C overall after filtering for engagement
numMice = length(learningEngaged);
cBefore = cell(1,numMice);
cAfter = cell(1,numMice);
for i = 1:numMice
    mouse = learningEngaged(i);
    lTNum = mouse.learnedFirstTask;
    upToLearningTrials = mouse.trialData(1:lTNum,:);
    eLTNum = sum(upToLearningTrials.Engagement);
    [rLicks,cLicks] = get_r_and_c_licks(learningEngaged,i,1,lTNum);
    [eRLicks,eCLicks] = get_r_and_c_licks2(learningEngaged,i,1,eLTNum);
    [~,~,~,c1] = dprime_and_c_licks(rLicks,cLicks);
    [~,~,~,c2] = dprime_and_c_licks(eRLicks,eCLicks);
    cBefore{i} = c1;
    cAfter{i} = c2;
end
[learningEngaged(:).cBefore] = cBefore{:};
[learningEngaged(:).cAfter] = cAfter{:};
c1 = [learningEngaged.cBefore];
c2 = [learningEngaged.cAfter];
%% Figure: C before and after removal of engagement
figure();
hold on;
plotBar({c1,c2},'C',{'All Trials','Engaged Trials'},['C for Learning Mice ',...
    'Before and After Filtering Non-Engaged Trials']);
hold off;
p = ttest_QZ(c1,c2,'C Before and After Filtering out Non-Engaged Trials: ');
