function [baselineLearningRewardTrace,baselineLearningCostTrace,learningRewardTrace,learningCostTrace,postLearningRewardTrace,postLearningCostTrace] = photometryPerMouseLearning(twdb,mouseID,mouseTrials,mouseFluorTrials,rewardTone,costTone,firstLearningPeriod)

learningTrial = first(twdb_lookup(twdb,'learnedFirstTask','key','mouseID',mouseID));

if learningTrial == -1
    learningTrial = height(mouseTrials);
end

baselineLearningTrial = round(firstLearningPeriod*learningTrial);
trialRange = 1:baselineLearningTrial;
[~,~,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials(trialRange,:),mouseFluorTrials(trialRange,:),rewardTone,costTone);
baselineLearningRewardTrace = get_dist_stats(rewardFluorTrials);
baselineLearningCostTrace = get_dist_stats(costFluorTrials);

trialRange = baselineLearningTrial+1:learningTrial;
[~,~,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials(trialRange,:),mouseFluorTrials(trialRange,:),rewardTone,costTone);
learningRewardTrace = get_dist_stats(rewardFluorTrials);
learningCostTrace = get_dist_stats(costFluorTrials);

if learningTrial~=height(mouseTrials)
    trialRange = learningTrial+1:height(mouseTrials);
    [~,~,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials(trialRange,:),mouseFluorTrials(trialRange,:),rewardTone,costTone);
    postLearningRewardTrace = get_dist_stats(rewardFluorTrials);
    postLearningCostTrace = get_dist_stats(costFluorTrials);
else
    postLearningRewardTrace = nan(1,98);
    postLearningCostTrace = nan(1,98);
end



