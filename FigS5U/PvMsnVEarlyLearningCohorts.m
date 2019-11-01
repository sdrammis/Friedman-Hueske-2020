function PvMsnVEarlyLearningCohorts(twdb)

load('pvmsnconn.mat');

Animals = pvmsnconn.ID;
Animals = unique(Animals);
%Animals = {};
% for i = 1:length(RawAnimals)
%     if strcmp(twdb_lookup(twdb, 'Health', 'key', 'mouseID', RawAnimals(i)), 'WT')
%         Animals{end+1} = RawAnimals(i);
%     end
% end

animalsStrio = {};
animalsMatrix = {};
animalsLearnedStrio = {};
animalsLearnedMatrix = {};
animalsNotLearnedStrio = {};
animalsNotLearnedMatrix = {};
animalsWTStrio = {};
animalsWTMatrix = {};
animalsHDStrio = {};
animalsHDMatrix = {};
for i = 1:length(Animals)
    if strcmp(first(twdb_lookup(twdb, 'intendedStriosomality', 'key', 'mouseID', Animals{i})), 'Strio')
        animalsStrio{end+1} = Animals(i);
        if strcmp(first(twdb_lookup(twdb, 'Health', 'key', 'mouseID', Animals{i})), 'WT')
            animalsWTStrio{end+1} = Animals(i);
        else
            animalsHDStrio{end+1} = Animals(i);
        end
        if first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', Animals{i})) == -1
            animalsNotLearnedStrio{end+1} = Animals(i);
        else
            animalsLearnedStrio{end+1} = Animals(i);
        end
    else
        animalsMatrix{end+1} = Animals(i);
        if strcmp(first(twdb_lookup(twdb, 'Health', 'key', 'mouseID', Animals{i})), 'WT')
            animalsWTMatrix{end+1} = Animals(i);
        else
            animalsHDMatrix{end+1} = Animals(i);
        end
        if first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', Animals{i})) == -1
            animalsNotLearnedMatrix{end+1} = Animals(i);
        else
            animalsLearnedMatrix{end+1} = Animals(i);
        end
    end
end

CompPvMsnDataStrio = num2cell(zeros(1, length(animalsStrio)));

for i = 1:length(animalsStrio)
    for j = 1:height(pvmsnconn)
        if strcmp(cell2mat(pvmsnconn.ID(j)), animalsStrio{i})
            connection = pvmsnconn.Connections(j);
            CompPvMsnDataStrio{i} = [CompPvMsnDataStrio{i}, connection];
        end
    end
end

for i = 1:length(CompPvMsnDataStrio)
    %CompPvMsnDataStrio{1,i}(1) = [];
    CompPvMsnDataStrio{i} = mean(CompPvMsnDataStrio{i});
end


badIndexStrio = {};
badIDStrio = {};
for i = 1:length(animalsStrio)
    if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsStrio{i}))
        badIndexStrio{end+1} = i;
        badIDStrio{end+1} = animalsStrio(i);
    end
end
animalsStrio([cell2mat(badIndexStrio)]) = [];
CompPvMsnDataStrio([cell2mat(badIndexStrio)]) = [];

TraceAreaStrio = {};
RewardTraceSumStrio = {};
CostTraceSumStrio = {};
cLstStrio = {};
dPrimeLstStrio = {};
doneStrio = {};
for i = 1:length(animalsStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsStrio(i), true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneStrio{end+1} = animalsStrio{i};
    TraceAreaStrio{end+1} = responseTraceArea;
    RewardTraceSumStrio{end+1} = responseRewardTraceSum;
    CostTraceSumStrio{end+1} = responseCostTraceSum;
    cLstStrio{end+1} = c;
    dPrimeLstStrio{end+1} = dPrime;
end

CompPvMsnDataMatrix = num2cell(zeros(1, length(animalsMatrix)));

for i = 1:length(animalsMatrix)
    for j = 1:height(pvmsnconn)
        if strcmp(cell2mat(pvmsnconn.ID(j)), animalsMatrix{i})
            connection = pvmsnconn.Connections(j);
            CompPvMsnDataMatrix{i} = [CompPvMsnDataMatrix{i}, connection];
        end
    end
end

for i = 1:length(CompPvMsnDataMatrix)
    %CompPvMsnDataMatrix{1,i}(1) = [];
    CompPvMsnDataMatrix{i} = mean(CompPvMsnDataMatrix{i});
end


badIndexMatrix = {};
badIDMatrix = {};
for i = 1:length(animalsMatrix)
    if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsMatrix{i}))
        badIndexMatrix{end+1} = i;
        badIDMatrix{end+1} = animalsMatrix(i);
    end
end
animalsMatrix([cell2mat(badIndexMatrix)]) = [];
CompPvMsnDataMatrix([cell2mat(badIndexMatrix)]) = [];

TraceAreaMatrix = {};
RewardTraceSumMatrix = {};
CostTraceSumMatrix = {};
cLstMatrix = {};
dPrimeLstMatrix = {};
doneMatrix = {};
for i = 1:length(animalsMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsMatrix(i), true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneMatrix{end+1} = animalsMatrix{i};
    TraceAreaMatrix{end+1} = responseTraceArea;
    RewardTraceSumMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumMatrix{end+1} = responseCostTraceSum;
    cLstMatrix{end+1} = c;
    dPrimeLstMatrix{end+1} = dPrime;
end

regressionPlot(TraceAreaStrio, CompPvMsnDataStrio)
regressionPlot(TraceAreaMatrix, CompPvMsnDataMatrix)

% CompPvMsnDataLearnedStrio = num2cell(zeros(1, length(animalsLearnedStrio)));
% 
% for i = 1:length(animalsLearnedStrio)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsLearnedStrio{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataLearnedStrio{i} = [CompPvMsnDataLearnedStrio{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataLearnedStrio)
%     %CompPvMsnDataLearnedStrio{1,i}(1) = [];
%     CompPvMsnDataLearnedStrio{i} = mean(CompPvMsnDataLearnedStrio{i});
% end
% 
% 
% badIndexLearnedStrio = {};
% badIDLearnedStrio = {};
% for i = 1:length(animalsLearnedStrio)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsLearnedStrio{i}))
%         badIndexLearnedStrio{end+1} = i;
%         badIDLearnedStrio{end+1} = animalsLearnedStrio(i);
%     end
% end
% animalsLearnedStrio([cell2mat(badIndexLearnedStrio)]) = [];
% CompPvMsnDataLearnedStrio([cell2mat(badIndexLearnedStrio)]) = [];
% 
% TraceAreaLearnedStrio = {};
% RewardTraceSumLearnedStrio = {};
% CostTraceSumLearnedStrio = {};
% cLstLearnedStrio = {};
% dPrimeLstLearnedStrio = {};
% doneLearnedStrio = {};
% for i = 1:length(animalsLearnedStrio)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsLearnedStrio(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneLearnedStrio{end+1} = animalsLearnedStrio{i};
%     TraceAreaLearnedStrio{end+1} = responseTraceArea;
%     RewardTraceSumLearnedStrio{end+1} = responseRewardTraceSum;
%     CostTraceSumLearnedStrio{end+1} = responseCostTraceSum;
%     cLstLearnedStrio{end+1} = c;
%     dPrimeLstLearnedStrio{end+1} = dPrime;
% end
% 
% CompPvMsnDataLearnedMatrix = num2cell(zeros(1, length(animalsLearnedMatrix)));
% 
% for i = 1:length(animalsLearnedMatrix)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsLearnedMatrix{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataLearnedMatrix{i} = [CompPvMsnDataLearnedMatrix{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataLearnedMatrix)
%     %CompPvMsnDataLearnedMatrix{1,i}(1) = [];
%     CompPvMsnDataLearnedMatrix{i} = mean(CompPvMsnDataLearnedMatrix{i});
% end
% 
% 
% badIndexLearnedMatrix = {};
% badIDLearnedMatrix = {};
% for i = 1:length(animalsLearnedMatrix)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsLearnedMatrix{i}))
%         badIndexLearnedMatrix{end+1} = i;
%         badIDLearnedMatrix{end+1} = animalsLearnedMatrix(i);
%     end
% end
% animalsLearnedMatrix([cell2mat(badIndexLearnedMatrix)]) = [];
% CompPvMsnDataLearnedMatrix([cell2mat(badIndexLearnedMatrix)]) = [];
% 
% TraceAreaLearnedMatrix = {};
% RewardTraceSumLearnedMatrix = {};
% CostTraceSumLearnedMatrix = {};
% cLstLearnedMatrix = {};
% dPrimeLstLearnedMatrix = {};
% doneLearnedMatrix = {};
% for i = 1:length(animalsLearnedMatrix)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsLearnedMatrix(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneLearnedMatrix{end+1} = animalsLearnedMatrix{i};
%     TraceAreaLearnedMatrix{end+1} = responseTraceArea;
%     RewardTraceSumLearnedMatrix{end+1} = responseRewardTraceSum;
%     CostTraceSumLearnedMatrix{end+1} = responseCostTraceSum;
%     cLstLearnedMatrix{end+1} = c;
%     dPrimeLstLearnedMatrix{end+1} = dPrime;
% end
% 
% CompPvMsnDataNotLearnedStrio = num2cell(zeros(1, length(animalsNotLearnedStrio)));
% 
% for i = 1:length(animalsNotLearnedStrio)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsNotLearnedStrio{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataNotLearnedStrio{i} = [CompPvMsnDataNotLearnedStrio{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataNotLearnedStrio)
%     %CompPvMsnDataNotLearnedStrio{1,i}(1) = [];
%     CompPvMsnDataNotLearnedStrio{i} = mean(CompPvMsnDataNotLearnedStrio{i});
% end
% 
% 
% badIndexNotLearnedStrio = {};
% badIDNotLearnedStrio = {};
% for i = 1:length(animalsNotLearnedStrio)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsNotLearnedStrio{i}))
%         badIndexNotLearnedStrio{end+1} = i;
%         badIDNotLearnedStrio{end+1} = animalsNotLearnedStrio(i);
%     end
% end
% animalsNotLearnedStrio([cell2mat(badIndexNotLearnedStrio)]) = [];
% CompPvMsnDataNotLearnedStrio([cell2mat(badIndexNotLearnedStrio)]) = [];
% 
% TraceAreaNotLearnedStrio = {};
% RewardTraceSumNotLearnedStrio = {};
% CostTraceSumNotLearnedStrio = {};
% cLstNotLearnedStrio = {};
% dPrimeLstNotLearnedStrio = {};
% doneNotLearnedStrio = {};
% for i = 1:length(animalsNotLearnedStrio)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsNotLearnedStrio(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneNotLearnedStrio{end+1} = animalsNotLearnedStrio{i};
%     TraceAreaNotLearnedStrio{end+1} = responseTraceArea;
%     RewardTraceSumNotLearnedStrio{end+1} = responseRewardTraceSum;
%     CostTraceSumNotLearnedStrio{end+1} = responseCostTraceSum;
%     cLstNotLearnedStrio{end+1} = c;
%     dPrimeLstNotLearnedStrio{end+1} = dPrime;
% end
% 
% CompPvMsnDataNotLearnedMatrix = num2cell(zeros(1, length(animalsNotLearnedMatrix)));
% 
% for i = 1:length(animalsNotLearnedMatrix)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsNotLearnedMatrix{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataNotLearnedMatrix{i} = [CompPvMsnDataNotLearnedMatrix{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataNotLearnedMatrix)
%     %CompPvMsnDataNotLearnedMatrix{1,i}(1) = [];
%     CompPvMsnDataNotLearnedMatrix{i} = mean(CompPvMsnDataNotLearnedMatrix{i});
% end
% 
% 
% badIndexNotLearnedMatrix = {};
% badIDNotLearnedMatrix = {};
% for i = 1:length(animalsNotLearnedMatrix)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsNotLearnedMatrix{i}))
%         badIndexNotLearnedMatrix{end+1} = i;
%         badIDNotLearnedMatrix{end+1} = animalsNotLearnedMatrix(i);
%     end
% end
% animalsNotLearnedMatrix([cell2mat(badIndexNotLearnedMatrix)]) = [];
% CompPvMsnDataNotLearnedMatrix([cell2mat(badIndexNotLearnedMatrix)]) = [];
% 
% TraceAreaNotLearnedMatrix = {};
% RewardTraceSumNotLearnedMatrix = {};
% CostTraceSumNotLearnedMatrix = {};
% cLstNotLearnedMatrix = {};
% dPrimeLstNotLearnedMatrix = {};
% doneNotLearnedMatrix = {};
% for i = 1:length(animalsNotLearnedMatrix)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsNotLearnedMatrix(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneNotLearnedMatrix{end+1} = animalsNotLearnedMatrix{i};
%     TraceAreaNotLearnedMatrix{end+1} = responseTraceArea;
%     RewardTraceSumNotLearnedMatrix{end+1} = responseRewardTraceSum;
%     CostTraceSumNotLearnedMatrix{end+1} = responseCostTraceSum;
%     cLstNotLearnedMatrix{end+1} = c;
%     dPrimeLstNotLearnedMatrix{end+1} = dPrime;
% end
% 
% CompPvMsnDataWTStrio = num2cell(zeros(1, length(animalsWTStrio)));
% 
% for i = 1:length(animalsWTStrio)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsWTStrio{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataWTStrio{i} = [CompPvMsnDataWTStrio{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataWTStrio)
%     %CompPvMsnDataWTStrio{1,i}(1) = [];
%     CompPvMsnDataWTStrio{i} = mean(CompPvMsnDataWTStrio{i});
% end
% 
% 
% badIndexWTStrio = {};
% badIDWTStrio = {};
% for i = 1:length(animalsWTStrio)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsWTStrio{i}))
%         badIndexWTStrio{end+1} = i;
%         badIDWTStrio{end+1} = animalsWTStrio(i);
%     end
% end
% animalsWTStrio([cell2mat(badIndexWTStrio)]) = [];
% CompPvMsnDataWTStrio([cell2mat(badIndexWTStrio)]) = [];
% 
% TraceAreaWTStrio = {};
% RewardTraceSumWTStrio = {};
% CostTraceSumWTStrio = {};
% cLstWTStrio = {};
% dPrimeLstWTStrio = {};
% doneWTStrio = {};
% for i = 1:length(animalsWTStrio)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsWTStrio(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneWTStrio{end+1} = animalsWTStrio{i};
%     TraceAreaWTStrio{end+1} = responseTraceArea;
%     RewardTraceSumWTStrio{end+1} = responseRewardTraceSum;
%     CostTraceSumWTStrio{end+1} = responseCostTraceSum;
%     cLstWTStrio{end+1} = c;
%     dPrimeLstWTStrio{end+1} = dPrime;
% end
% 
% CompPvMsnDataWTMatrix = num2cell(zeros(1, length(animalsWTMatrix)));
% 
% for i = 1:length(animalsWTMatrix)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsWTMatrix{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataWTMatrix{i} = [CompPvMsnDataWTMatrix{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataWTMatrix)
%     %CompPvMsnDataWTMatrix{1,i}(1) = [];
%     CompPvMsnDataWTMatrix{i} = mean(CompPvMsnDataWTMatrix{i});
% end
% 
% 
% badIndexWTMatrix = {};
% badIDWTMatrix = {};
% for i = 1:length(animalsWTMatrix)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsWTMatrix{i}))
%         badIndexWTMatrix{end+1} = i;
%         badIDWTMatrix{end+1} = animalsWTMatrix(i);
%     end
% end
% animalsWTMatrix([cell2mat(badIndexWTMatrix)]) = [];
% CompPvMsnDataWTMatrix([cell2mat(badIndexWTMatrix)]) = [];
% 
% TraceAreaWTMatrix = {};
% RewardTraceSumWTMatrix = {};
% CostTraceSumWTMatrix = {};
% cLstWTMatrix = {};
% dPrimeLstWTMatrix = {};
% doneWTMatrix = {};
% for i = 1:length(animalsWTMatrix)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsWTMatrix(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneWTMatrix{end+1} = animalsWTMatrix{i};
%     TraceAreaWTMatrix{end+1} = responseTraceArea;
%     RewardTraceSumWTMatrix{end+1} = responseRewardTraceSum;
%     CostTraceSumWTMatrix{end+1} = responseCostTraceSum;
%     cLstWTMatrix{end+1} = c;
%     dPrimeLstWTMatrix{end+1} = dPrime;
% end
% 
% CompPvMsnDataHDStrio = num2cell(zeros(1, length(animalsHDStrio)));
% 
% for i = 1:length(animalsHDStrio)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsHDStrio{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataHDStrio{i} = [CompPvMsnDataHDStrio{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataHDStrio)
%     %CompPvMsnDataHDStrio{1,i}(1) = [];
%     CompPvMsnDataHDStrio{i} = mean(CompPvMsnDataHDStrio{i});
% end
% 
% 
% badIndexHDStrio = {};
% badIDHDStrio = {};
% for i = 1:length(animalsHDStrio)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsHDStrio{i}))
%         badIndexHDStrio{end+1} = i;
%         badIDHDStrio{end+1} = animalsHDStrio(i);
%     end
% end
% animalsHDStrio([cell2mat(badIndexHDStrio)]) = [];
% CompPvMsnDataHDStrio([cell2mat(badIndexHDStrio)]) = [];
% 
% TraceAreaHDStrio = {};
% RewardTraceSumHDStrio = {};
% CostTraceSumHDStrio = {};
% cLstHDStrio = {};
% dPrimeLstHDStrio = {};
% doneHDStrio = {};
% for i = 1:length(animalsHDStrio)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsHDStrio(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneHDStrio{end+1} = animalsHDStrio{i};
%     TraceAreaHDStrio{end+1} = responseTraceArea;
%     RewardTraceSumHDStrio{end+1} = responseRewardTraceSum;
%     CostTraceSumHDStrio{end+1} = responseCostTraceSum;
%     cLstHDStrio{end+1} = c;
%     dPrimeLstHDStrio{end+1} = dPrime;
% end
% 
% CompPvMsnDataHDMatrix = num2cell(zeros(1, length(animalsHDMatrix)));
% 
% for i = 1:length(animalsHDMatrix)
%     for j = 1:height(pvmsnconn)
%         if strcmp(cell2mat(pvmsnconn.ID(j)), animalsHDMatrix{i})
%             connection = pvmsnconn.Connections(j);
%             CompPvMsnDataHDMatrix{i} = [CompPvMsnDataHDMatrix{i}, connection];
%         end
%     end
% end
% 
% for i = 1:length(CompPvMsnDataHDMatrix)
%     %CompPvMsnDataHDMatrix{1,i}(1) = [];
%     CompPvMsnDataHDMatrix{i} = mean(CompPvMsnDataHDMatrix{i});
% end
% 
% 
% badIndexHDMatrix = {};
% badIDHDMatrix = {};
% for i = 1:length(animalsHDMatrix)
%     if isempty(twdb_lookup(twdb, 'index', 'key', 'mouseID', animalsHDMatrix{i}))
%         badIndexHDMatrix{end+1} = i;
%         badIDHDMatrix{end+1} = animalsHDMatrix(i);
%     end
% end
% animalsHDMatrix([cell2mat(badIndexHDMatrix)]) = [];
% CompPvMsnDataHDMatrix([cell2mat(badIndexHDMatrix)]) = [];
% 
% TraceAreaHDMatrix = {};
% RewardTraceSumHDMatrix = {};
% CostTraceSumHDMatrix = {};
% cLstHDMatrix = {};
% dPrimeLstHDMatrix = {};
% doneHDMatrix = {};
% for i = 1:length(animalsHDMatrix)
%     [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, animalsHDMatrix(i), true, false);
%     [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
%     doneHDMatrix{end+1} = animalsHDMatrix{i};
%     TraceAreaHDMatrix{end+1} = responseTraceArea;
%     RewardTraceSumHDMatrix{end+1} = responseRewardTraceSum;
%     CostTraceSumHDMatrix{end+1} = responseCostTraceSum;
%     cLstHDMatrix{end+1} = c;
%     dPrimeLstHDMatrix{end+1} = dPrime;
% end