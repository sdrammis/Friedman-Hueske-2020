function [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr,lrr,lrc] = get_dprime_traceArea(mouseTrials,mouseFluorTrials,rewardTone,costTone,threshold)
 
    responsePeriod = 39:46;
    [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    % lick rates
    lrr = mean(rewardTrials.ResponseLickFrequency);
    lrc = mean(costTrials.ResponseLickFrequency);
    % stats based on threshold
    if threshold == 1
        [tpr,fpr,dPrime,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    elseif threshold == 2
        [tpr,fpr,dPrime,c] = dprime_and_c_licks2(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    else % threshold == 3
        [tpr,fpr,dPrime,c] = dprime_and_c_licks3(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    end
 
    [mReward, ~, ~] = get_dist_stats(rewardFluorTrials);
    [mCost, ~, ~] = get_dist_stats(costFluorTrials);
    responseRewardTrace = mReward(responsePeriod);
    responseCostTrace = mCost(responsePeriod);
    responseTraceArea = sum(responseRewardTrace-responseCostTrace);
    responseRewardTraceSum = sum(responseRewardTrace);
    responseCostTraceSum = sum(responseCostTrace);
end