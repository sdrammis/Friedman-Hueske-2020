function vGlutVEarlyLearning1(twdb)

load('vGlutDataRaw.mat');
load('vGlutDataNormalized.mat');
load('maxiHDm.mat');
load('maxiHDs.mat');
load('maxiWTMLO.mat');
load('maxiWTMLY.mat');
load('maxiWTMNLO.mat');
load('maxiWTSLO.mat');
load('maxiWTSLY.mat');
load('maxiWTSNLO.mat');


animals = vGlutDataRaw.ID;
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
for i = 1:length(animals)
    if strcmp(first(twdb_lookup(twdb, 'intendedStriosomality', 'key', 'mouseID', num2str(animals(i)))), 'Strio')
        animalsStrio{end+1} = animals(i);
        if strcmp(first(twdb_lookup(twdb, 'Health', 'key', 'mouseID', num2str(animals(i)))), 'WT')
            animalsWTStrio{end+1} = animals(i);
        else
            animalsHDStrio{end+1} = animals(i);
        end
        if first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', num2str(animals(i)))) == -1
            animalsNotLearnedStrio{end+1} = animals(i);
        else
            animalsLearnedStrio{end+1} = animals(i);
        end
    else
        animalsMatrix{end+1} = animals(i);
        if strcmp(first(twdb_lookup(twdb, 'Health', 'key', 'mouseID', num2str(animals(i)))), 'WT')
            animalsWTMatrix{end+1} = animals(i);
        else
            animalsHDMatrix{end+1} = animals(i);
        end
        if first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', num2str(animals(i)))) == -1
            animalsNotLearnedMatrix{end+1} = animals(i);
        else
            animalsLearnedMatrix{end+1} = animals(i);
        end
    end
end


vGlutDataStrio = {};
for i = 1:length(animalsStrio)
    for k = 1:height(vGlutDataRaw)
        if animalsStrio{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Strio{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataStrio{end+1} = data;
        end
    end
end

vGlutDataMatrix = {};
for i = 1:length(animalsMatrix)
    for k = 1:height(vGlutDataRaw)
        if animalsMatrix{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Matrix{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataMatrix{end+1} = data;
        end
    end
end

vGlutDataWTStrio = {};
for i = 1:length(animalsWTStrio)
    for k = 1:height(vGlutDataRaw)
        if animalsWTStrio{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Strio{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataWTStrio{end+1} = data;
        end
    end
end

vGlutDataWTMatrix = {};
for i = 1:length(animalsWTMatrix)
    for k = 1:height(vGlutDataRaw)
        if animalsWTMatrix{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Matrix{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataWTMatrix{end+1} = data;
        end
    end
end            

vGlutDataHDStrio = {};
for i = 1:length(animalsHDStrio)
    for k = 1:height(vGlutDataRaw)
        if animalsHDStrio{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Strio{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataHDStrio{end+1} = data;
        end
    end
end

vGlutDataHDMatrix = {};
for i = 1:length(animalsHDMatrix)
    for k = 1:height(vGlutDataRaw)
        if animalsHDMatrix{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Matrix{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataHDMatrix{end+1} = data;
        end
    end
end

vGlutDataLearnedStrio = {};
for i = 1:length(animalsLearnedStrio)
    for k = 1:height(vGlutDataRaw)
        if animalsLearnedStrio{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Strio{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataLearnedStrio{end+1} = data;
        end
    end
end

vGlutDataLearnedMatrix = {};
for i = 1:length(animalsLearnedMatrix)
    for k = 1:height(vGlutDataRaw)
        if animalsLearnedMatrix{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Matrix{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataLearnedMatrix{end+1} = data;
        end
    end
end

vGlutDataNotLearnedStrio = {};
for i = 1:length(animalsNotLearnedStrio)
    for k = 1:height(vGlutDataRaw)
        if animalsNotLearnedStrio{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Strio{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataNotLearnedStrio{end+1} = data;
        end
    end
end

vGlutDataNotLearnedMatrix = {};
for i = 1:length(animalsNotLearnedMatrix)
    for k = 1:height(vGlutDataRaw)
        if animalsNotLearnedMatrix{i} == vGlutDataRaw.ID(k)
            [f,x] = ecdf(vGlutDataRaw.Matrix{k,1});
            x8 = 0;
            x14 = 0;
            for j = 1:length(x)
                if x(j) == 8
                    x8 = j; 
                end
                if x(j) == 14
                    x14 = j;
                end
            end
            if x14 == 0
                x14 = length(x);
            end
            ftest = f([x8:x14]);
            data = sum(ftest);
            vGlutDataNotLearnedMatrix{end+1} = data;
        end
    end
end

TraceAreaStrio = {};
RewardTraceSumStrio = {};
CostTraceSumStrio = {};
cLstStrio = {};
dPrimeLstStrio = {};
doneStrio = {};
for i = 1:length(animalsStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsStrio{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneStrio{end+1} = animalsStrio(i);
    TraceAreaStrio{end+1} = responseTraceArea;
    RewardTraceSumStrio{end+1} = responseRewardTraceSum;
    CostTraceSumStrio{end+1} = responseCostTraceSum;
    cLstStrio{end+1} = c;
    dPrimeLstStrio{end+1} = dPrime;
end

TraceAreaMatrix = {};
RewardTraceSumMatrix = {};
CostTraceSumMatrix = {};
cLstMatrix = {};
dPrimeLstMatrix = {};
doneMatrix = {};
for i = 1:length(animalsMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsMatrix{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneMatrix{end+1} = animalsMatrix(i);
    TraceAreaMatrix{end+1} = responseTraceArea;
    RewardTraceSumMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumMatrix{end+1} = responseCostTraceSum;
    cLstMatrix{end+1} = c;
    dPrimeLstMatrix{end+1} = dPrime;
end

TraceAreaLearnedStrio = {};
RewardTraceSumLearnedStrio = {};
CostTraceSumLearnedStrio = {};
cLstLearnedStrio = {};
dPrimeLstLearnedStrio = {};
doneLearnedStrio = {};
for i = 1:length(animalsLearnedStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsLearnedStrio{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneLearnedStrio{end+1} = animalsLearnedStrio(i);
    TraceAreaLearnedStrio{end+1} = responseTraceArea;
    RewardTraceSumLearnedStrio{end+1} = responseRewardTraceSum;
    CostTraceSumLearnedStrio{end+1} = responseCostTraceSum;
    cLstLearnedStrio{end+1} = c;
    dPrimeLstLearnedStrio{end+1} = dPrime;
end

TraceAreaLearnedMatrix = {};
RewardTraceSumLearnedMatrix = {};
CostTraceSumLearnedMatrix = {};
cLstLearnedMatrix = {};
dPrimeLstLearnedMatrix = {};
doneLearnedMatrix = {};
for i = 1:length(animalsLearnedMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsLearnedMatrix{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneLearnedMatrix{end+1} = animalsLearnedMatrix(i);
    TraceAreaLearnedMatrix{end+1} = responseTraceArea;
    RewardTraceSumLearnedMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumLearnedMatrix{end+1} = responseCostTraceSum;
    cLstLearnedMatrix{end+1} = c;
    dPrimeLstLearnedMatrix{end+1} = dPrime;
end

TraceAreaNotLearnedStrio = {};
RewardTraceSumNotLearnedStrio = {};
CostTraceSumNotLearnedStrio = {};
cLstNotLearnedStrio = {};
dPrimeLstNotLearnedStrio = {};
doneNotLearnedStrio = {};
for i = 1:length(animalsNotLearnedStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsNotLearnedStrio{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneNotLearnedStrio{end+1} = animalsNotLearnedStrio(i);
    TraceAreaNotLearnedStrio{end+1} = responseTraceArea;
    RewardTraceSumNotLearnedStrio{end+1} = responseRewardTraceSum;
    CostTraceSumNotLearnedStrio{end+1} = responseCostTraceSum;
    cLstNotLearnedStrio{end+1} = c;
    dPrimeLstNotLearnedStrio{end+1} = dPrime;
end

TraceAreaNotLearnedMatrix = {};
RewardTraceSumNotLearnedMatrix = {};
CostTraceSumNotLearnedMatrix = {};
cLstNotLearnedMatrix = {};
dPrimeLstNotLearnedMatrix = {};
doneNotLearnedMatrix = {};
for i = 1:length(animalsNotLearnedMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsNotLearnedMatrix{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneNotLearnedMatrix{end+1} = animalsNotLearnedMatrix(i);
    TraceAreaNotLearnedMatrix{end+1} = responseTraceArea;
    RewardTraceSumNotLearnedMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumNotLearnedMatrix{end+1} = responseCostTraceSum;
    cLstNotLearnedMatrix{end+1} = c;
    dPrimeLstNotLearnedMatrix{end+1} = dPrime;
end

TraceAreaWTStrio = {};
RewardTraceSumWTStrio = {};
CostTraceSumWTStrio = {};
cLstWTStrio = {};
dPrimeLstWTStrio = {};
doneWTStrio = {};
for i = 1:length(animalsWTStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsWTStrio{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneWTStrio{end+1} = animalsWTStrio(i);
    TraceAreaWTStrio{end+1} = responseTraceArea;
    RewardTraceSumWTStrio{end+1} = responseRewardTraceSum;
    CostTraceSumWTStrio{end+1} = responseCostTraceSum;
    cLstWTStrio{end+1} = c;
    dPrimeLstWTStrio{end+1} = dPrime;
end

TraceAreaWTMatrix = {};
RewardTraceSumWTMatrix = {};
CostTraceSumWTMatrix = {};
cLstWTMatrix = {};
dPrimeLstWTMatrix = {};
doneWTMatrix = {};
for i = 1:length(animalsWTMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsWTMatrix{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneWTMatrix{end+1} = animalsWTMatrix(i);
    TraceAreaWTMatrix{end+1} = responseTraceArea;
    RewardTraceSumWTMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumWTMatrix{end+1} = responseCostTraceSum;
    cLstWTMatrix{end+1} = c;
    dPrimeLstWTMatrix{end+1} = dPrime;
end

TraceAreaHDStrio = {};
RewardTraceSumHDStrio = {};
CostTraceSumHDStrio = {};
cLstHDStrio = {};
dPrimeLstHDStrio = {};
doneHDStrio = {};
for i = 1:length(animalsHDStrio)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsHDStrio{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneHDStrio{end+1} = animalsHDStrio(i);
    TraceAreaHDStrio{end+1} = responseTraceArea;
    RewardTraceSumHDStrio{end+1} = responseRewardTraceSum;
    CostTraceSumHDStrio{end+1} = responseCostTraceSum;
    cLstHDStrio{end+1} = c;
    dPrimeLstHDStrio{end+1} = dPrime;
end

TraceAreaHDMatrix = {};
RewardTraceSumHDMatrix = {};
CostTraceSumHDMatrix = {};
cLstHDMatrix = {};
dPrimeLstHDMatrix = {};
doneHDMatrix = {};
for i = 1:length(animalsHDMatrix)
    [mouseTrials,mouseFluorTrials,rewardTone,costTone, numSessions] = get_all_trials(twdb, {num2str(animalsHDMatrix{i})}, true, false);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials{1,1}(1:200,:),mouseFluorTrials{1,1}(1:200,:),rewardTone,costTone);
    doneHDMatrix{end+1} = animalsHDMatrix(i);
    TraceAreaHDMatrix{end+1} = responseTraceArea;
    RewardTraceSumHDMatrix{end+1} = responseRewardTraceSum;
    CostTraceSumHDMatrix{end+1} = responseCostTraceSum;
    cLstHDMatrix{end+1} = c;
    dPrimeLstHDMatrix{end+1} = dPrime;
end

regressionPlot(TraceAreaStrio, vGlutDataStrio)
regressionPlot(TraceAreaMatrix, vGlutDataMatrix)