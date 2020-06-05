function sessionDistributions = sessionDistributions_DREADD(twdb,sessionIdx,period,bin_size)

sessionDistributions = table;
mouseID = twdb(sessionIdx).mouseID;
[mouseTrials,fluorTrials,rewardTone,costTone] = behaviorAndFluorescenceData(twdb, mouseID,sessionIdx);
[spikes,mouseTrialTimes,spikeHeights,spikeLengths] = spikesByPeriod(twdb(sessionIdx),period);
mouseSpikes = [spikes spikeHeights spikeLengths];
bins = fliplr(height(mouseTrials):-bin_size:0);
for b = 1:length(bins)-1
    bin_range = bins(b)+1:bins(b+1);
    bin_mouseTrials = mouseTrials(bin_range,:);
    bin_fluorTrials = fluorTrials(bin_range,:);
    bin_spikes =  mouseSpikes(bin_range,:);
    bin_trialTimes = mouseTrialTimes(bin_range);
    
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
    [responseLickFrequencyReward,responseLickFrequencyCost,acceptanceRateReward,acceptanceRateCost] = get_lickFrequency_acceptanceRate(bin_mouseTrials,rewardTone,costTone);
    [rewardFrequency,costFrequency,spikeHeightsReward,spikeHeightsCost,spikeLengthsReward,spikeLengthsCost] = reward_and_cost_trials_spikes(bin_mouseTrials,bin_spikes,bin_trialTimes,rewardTone,costTone);

    sessionDistributions.dPrime(b) = dPrime;
    sessionDistributions.responseTraceArea(b) = responseTraceArea;
    sessionDistributions.responseRewardTraceSum(b) = responseRewardTraceSum;
    sessionDistributions.responseCostTraceSum(b) = responseCostTraceSum;
    sessionDistributions.c(b) = c;
    sessionDistributions.responseLickFrequencyReward(b) = responseLickFrequencyReward;
    sessionDistributions.responseLickFrequencyCost(b) = responseLickFrequencyCost;
    sessionDistributions.acceptanceRateReward(b) = acceptanceRateReward;
    sessionDistributions.acceptanceRateCost(b) = acceptanceRateCost;
    sessionDistributions.rewardFrequency(b) = rewardFrequency;
    sessionDistributions.costFrequency(b) = costFrequency;
    sessionDistributions.spikeHeightsReward(b) = spikeHeightsReward;
    sessionDistributions.spikeHeightsCost(b) = spikeHeightsCost;
    sessionDistributions.spikeLengthsReward(b) = spikeLengthsReward;
    sessionDistributions.spikeLengthsCost(b) = spikeLengthsCost;
end