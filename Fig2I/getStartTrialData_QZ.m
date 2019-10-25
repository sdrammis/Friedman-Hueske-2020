% Author: QZ
% 07/16/2019
function [trials,fluorTrials,rewardTone,costTone] = getStartTrialData_QZ(twdb,miceType,msID)
% gets photometry and trial data for the 200 trials before the learning
% trial
mouseData = getMouseData_QZ(twdb,msID);
sortedData = sortMouseData_QZ(mouseData);
bIdx = first(twdb_lookup(table2struct(miceType),'index','key','mouseID',...
    msID));
numTrials = height(miceType.trialData{bIdx});
learnTrial = sortedData.learnedFirstTask(1);
if learnTrial >= 400
    numStart = 200;
elseif learnTrial >= 300 % [300,399] - 150 trials per
    numStart = 150;
elseif learnTrial >= 200 % [200,299] - 100 trials per
    numStart = 100;
elseif learnTrial >= 1 % [1,199] - shouldn't be applicable, but here anyway
    numStart = ceil(learnTrial/2);
else % -1, doesn't learn
    if numTrials >= 200
        numStart = 200;
    elseif numTrials >= 150
        numStart = 150;
    elseif numTrials >= 100
        numStart = 100;
    else
        numStart = numTrials;
    end
end
twdbIdxs = [];
decum = numStart;
for i = 1:height(sortedData)
    sessionTrials = sortedData.trialData{i};
    if ~isempty(sessionTrials)
        twdbIdxs = [twdbIdxs,sortedData.index(i)];
        if decum > height(sessionTrials)
    %         trials = [trials;sessionTrials];
            decum = decum - height(sessionTrials);
        else
    %         trials = [trials;sessionTrials(1:numStart,:)];
            n = i;
            break;
        end
    end
end
% idxs = sortedData.index(1:n);
[mT,fT,rewardTone,costTone,~] = get_all_trials(twdb,msID,twdbIdxs);
trials = mT(1:numStart,:);
fluorTrials = fT(1:numStart,:);
end