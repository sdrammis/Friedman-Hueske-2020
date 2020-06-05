function [dPrime,mRewardTrials,mCostTrials,c,tpr,fpr] = get_dprime_traceArea_UPDATE2(mouseTrials,mouseFluorTrials,rewardTone,costTone)
% behavioral stats are single values
% traces are arrays (1 value for each trial)
    responsePeriod = 39:46;
    [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    
    [tpr,fpr,dPrime,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    
    responseRewardTrials = rewardFluorTrials(:,responsePeriod);
    responseCostTrials = costFluorTrials(:,responsePeriod);
    mRewardTrials = mean(responseRewardTrials,2);
    mCostTrials = mean(responseCostTrials,2);
end