function [dPrime,traceArea,rewardTraceSum,costTraceSum,c,tpr,fpr,rLickFreq,...
    cLickFreq] = get_dprime_traceArea_edit3QZ(mouseTrials,mouseFluorTrials,rewardTone,costTone)
% From Helper Functions 
    [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    rLickFreq = rewardTrials.ResponseLickFrequency;
    cLickFreq = costTrials.ResponseLickFrequency;
    [tpr,fpr,dPrime,c] = dprime_and_c_licks(rLickFreq,cLickFreq);
    
    rewardTrace = nanmean(rewardFluorTrials);
    costTrace = nanmean(costFluorTrials);
    traceArea = rewardTrace-costTrace;
    rewardTraceSum = rewardTrace;
    costTraceSum = costTrace;
end