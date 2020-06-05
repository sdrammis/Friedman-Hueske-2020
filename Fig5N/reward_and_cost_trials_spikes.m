function [rewardFrequency,costFrequency,spikeHeightsReward,spikeHeightsCost,spikeLengthsReward,spikeLengthsCost] = reward_and_cost_trials_spikes(mouseTrials,mouseSpikes,mouseTrialTimes,rewardTone,costTone)


rewardIdx = mouseTrials.StimulusID == rewardTone;
costIdx = mouseTrials.StimulusID == costTone;
mouseSpikesReward = mouseSpikes(rewardIdx,1);
mouseSpikesCost = mouseSpikes(costIdx,1);

mouseTrialTimesReward = mouseTrialTimes(rewardIdx);
mouseTrialTimesCost = mouseTrialTimes(costIdx);

rewardFrequency = nansum(mouseSpikesReward)/sum(mouseTrialTimesReward);
costFrequency = nansum(mouseSpikesCost)/sum(mouseTrialTimesCost);


spikeHeightsReward = nanmean(mouseSpikes(rewardIdx,2));
spikeHeightsCost = nanmean(mouseSpikes(costIdx,2));
spikeLengthsReward = nanmean(mouseSpikes(rewardIdx,3));
spikeLengthsCost = nanmean(mouseSpikes(costIdx,3));
