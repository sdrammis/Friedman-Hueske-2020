function [responseLickFrequencyReward,responseLickFrequencyCost,acceptanceRateReward,acceptanceRateCost] = get_lickFrequency_acceptanceRate(mouseTrials,rewardTone,costTone)

    [rewardTrials,costTrials] = reward_and_cost_trials(mouseTrials,[],rewardTone,costTone);

    responseLickFrequencyReward = nanmean(rewardTrials.ResponseLickFrequency);
    responseLickFrequencyCost = nanmean(costTrials.ResponseLickFrequency);
    
    acceptanceRateReward = nanmean(rewardTrials.ResponseLickFrequency>0);
    acceptanceRateCost = nanmean(costTrials.ResponseLickFrequency>0);

end