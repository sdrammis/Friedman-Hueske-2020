function [rewardFluorescenceBins,costFluorescenceBins] = dPrimeRange(dPrimeRange,bin_size,mouseTrials,mouseFluorTrials,rewardTone,costTone)

rewardFluorescenceBins = [];
costFluorescenceBins = [];
for b = 1:bin_size:height(mouseTrials)
    binRange = b:b+bin_size-1;
    if sum(binRange > height(mouseTrials))
        continue
    end
    [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials(binRange,:),mouseFluorTrials(binRange,:),rewardTone,costTone);
    [~, ~, dPrime] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
    if and(dPrime<=dPrimeRange(2),dPrime>=dPrimeRange(1))
        rewardFluorescenceBins = [rewardFluorescenceBins; get_dist_stats(rewardFluorTrials)];
        costFluorescenceBins = [costFluorescenceBins; get_dist_stats(costFluorTrials)];
        
    end
end

