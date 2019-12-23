function SpinesVEarlyLearningCohorts(twdb)

load('SpineData.mat');
load('CompSpinesData.mat');

Animals = SpineData.ID;
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

CompSpinesDataStrio = num2cell(zeros(1, length(animalsStrio)));

for i = 1:length(animalsStrio)
    for j = 1:height(SpineData)
        if strcmp(cell2mat(SpineData.ID(j)), animalsStrio{i})
            density = SpineData.VarName7(j)/SpineData.VarName6(j);
            if isnan(density)
                continue
            end
            if density == 0
                continue
            end
            CompSpinesDataStrio{i} = [CompSpinesDataStrio{i}, density];
        end
    end
end

for i = 1:length(CompSpinesDataStrio)
    CompSpinesDataStrio{1,i}(1) = [];
    CompSpinesDataStrio{i} = mean(CompSpinesDataStrio{i});
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
CompSpinesDataStrio([cell2mat(badIndexStrio)]) = [];

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

CompSpinesDataMatrix = num2cell(zeros(1, length(animalsMatrix)));

for i = 1:length(animalsMatrix)
    for j = 1:height(SpineData)
        if strcmp(cell2mat(SpineData.ID(j)), animalsMatrix{i})
            density = SpineData.VarName7(j)/SpineData.VarName6(j);
            if isnan(density)
                continue
            end
            if density == 0
                continue
            end
            CompSpinesDataMatrix{i} = [CompSpinesDataMatrix{i}, density];
        end
    end
end

for i = 1:length(CompSpinesDataMatrix)
    CompSpinesDataMatrix{1,i}(1) = [];
    CompSpinesDataMatrix{i} = mean(CompSpinesDataMatrix{i});
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
CompSpinesDataMatrix([cell2mat(badIndexMatrix)]) = [];

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

regressionPlot(TraceAreaStrio, CompSpinesDataStrio)
regressionPlot(TraceAreaMatrix, CompSpinesDataMatrix)

% CompSpinesDataWTStrio = num2cell(zeros(1, length(animalsWTStrio)));
% 
% for i = 1:length(animalsWTStrio)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsWTStrio{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataWTStrio{i} = [CompSpinesDataWTStrio{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataWTStrio)
%     CompSpinesDataWTStrio{1,i}(1) = [];
%     CompSpinesDataWTStrio{i} = mean(CompSpinesDataWTStrio{i});
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
% CompSpinesDataWTStrio([cell2mat(badIndexWTStrio)]) = [];
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
% CompSpinesDataWTMatrix = num2cell(zeros(1, length(animalsWTMatrix)));
% 
% for i = 1:length(animalsWTMatrix)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsWTMatrix{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataWTMatrix{i} = [CompSpinesDataWTMatrix{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataWTMatrix)
%     CompSpinesDataWTMatrix{1,i}(1) = [];
%     CompSpinesDataWTMatrix{i} = mean(CompSpinesDataWTMatrix{i});
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
% CompSpinesDataWTMatrix([cell2mat(badIndexWTMatrix)]) = [];
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
% CompSpinesDataHDStrio = num2cell(zeros(1, length(animalsHDStrio)));
% 
% for i = 1:length(animalsHDStrio)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsHDStrio{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataHDStrio{i} = [CompSpinesDataHDStrio{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataHDStrio)
%     CompSpinesDataHDStrio{1,i}(1) = [];
%     CompSpinesDataHDStrio{i} = mean(CompSpinesDataHDStrio{i});
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
% CompSpinesDataHDStrio([cell2mat(badIndexHDStrio)]) = [];
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
% CompSpinesDataHDMatrix = num2cell(zeros(1, length(animalsHDMatrix)));
% 
% for i = 1:length(animalsHDMatrix)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsHDMatrix{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataHDMatrix{i} = [CompSpinesDataHDMatrix{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataHDMatrix)
%     CompSpinesDataHDMatrix{1,i}(1) = [];
%     CompSpinesDataHDMatrix{i} = mean(CompSpinesDataHDMatrix{i});
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
% CompSpinesDataHDMatrix([cell2mat(badIndexHDMatrix)]) = [];
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
% 
% CompSpinesDataLearnedStrio = num2cell(zeros(1, length(animalsLearnedStrio)));
% 
% for i = 1:length(animalsLearnedStrio)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsLearnedStrio{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataLearnedStrio{i} = [CompSpinesDataLearnedStrio{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataLearnedStrio)
%     CompSpinesDataLearnedStrio{1,i}(1) = [];
%     CompSpinesDataLearnedStrio{i} = mean(CompSpinesDataLearnedStrio{i});
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
% CompSpinesDataLearnedStrio([cell2mat(badIndexLearnedStrio)]) = [];
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
% CompSpinesDataNotLearnedStrio = num2cell(zeros(1, length(animalsNotLearnedStrio)));
% 
% for i = 1:length(animalsNotLearnedStrio)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsNotLearnedStrio{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataNotLearnedStrio{i} = [CompSpinesDataNotLearnedStrio{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataNotLearnedStrio)
%     CompSpinesDataNotLearnedStrio{1,i}(1) = [];
%     CompSpinesDataNotLearnedStrio{i} = mean(CompSpinesDataNotLearnedStrio{i});
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
% CompSpinesDataNotLearnedStrio([cell2mat(badIndexNotLearnedStrio)]) = [];
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
% CompSpinesDataLearnedMatrix = num2cell(zeros(1, length(animalsLearnedMatrix)));
% 
% for i = 1:length(animalsLearnedMatrix)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsLearnedMatrix{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataLearnedMatrix{i} = [CompSpinesDataLearnedMatrix{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataLearnedMatrix)
%     CompSpinesDataLearnedMatrix{1,i}(1) = [];
%     CompSpinesDataLearnedMatrix{i} = mean(CompSpinesDataLearnedMatrix{i});
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
% CompSpinesDataLearnedMatrix([cell2mat(badIndexLearnedMatrix)]) = [];
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
% CompSpinesDataNotLearnedMatrix = num2cell(zeros(1, length(animalsNotLearnedMatrix)));
% 
% for i = 1:length(animalsNotLearnedMatrix)
%     for j = 1:height(SpineData)
%         if strcmp(cell2mat(SpineData.ID(j)), animalsNotLearnedMatrix{i})
%             density = SpineData.VarName7(j)/SpineData.VarName6(j);
%             if isnan(density)
%                 continue
%             end
%             if density == 0
%                 continue
%             end
%             CompSpinesDataNotLearnedMatrix{i} = [CompSpinesDataNotLearnedMatrix{i}, density];
%         end
%     end
% end
% 
% for i = 1:length(CompSpinesDataNotLearnedMatrix)
%     CompSpinesDataNotLearnedMatrix{1,i}(1) = [];
%     CompSpinesDataNotLearnedMatrix{i} = mean(CompSpinesDataNotLearnedMatrix{i});
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
% CompSpinesDataNotLearnedMatrix([cell2mat(badIndexNotLearnedMatrix)]) = [];
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