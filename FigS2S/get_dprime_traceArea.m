function [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(mouseTrials,mouseFluorTrials,rewardTone,costTone)
    
    [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    
    [tpr,fpr,dPrime,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    
    
    %{
    [mReward, ~, ~] = get_dist_stats(rewardFluorTrials);
    [mCost, ~, ~] = get_dist_stats(costFluorTrials);
    responseRewardTrace = mReward(responsePeriod);
    responseCostTrace = mCost(responsePeriod);
    responseTraceArea = sum(responseRewardTrace-responseCostTrace);
    responseRewardTraceSum = sum(responseRewardTrace);
    responseCostTraceSum = sum(responseCostTrace);
    %}
    
    responseRewardTrace = nanmean(rewardFluorTrials);
    responseCostTrace = nanmean(costFluorTrials);
    responseTraceArea = responseRewardTrace-responseCostTrace;
    responseRewardTraceSum = responseRewardTrace;
    responseCostTraceSum = responseCostTrace;
end