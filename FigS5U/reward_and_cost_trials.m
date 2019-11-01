function [rewardTrials, costTrials, rewardFluorTrials, costFluorTrials] = reward_and_cost_trials(mouseTrials, mouseFluorTrials, rewardTone, costTone)

% Determine indices based on given reward and cost tones
rewardIdx = mouseTrials.StimulusID == rewardTone;
costIdx = mouseTrials.StimulusID == costTone;

% Use indices to extract correct reward/cost trial and fluorescence data
rewardTrials = mouseTrials(rewardIdx, :);
costTrials = mouseTrials(costIdx, :);

rewardFluorTrials = mouseFluorTrials(rewardIdx, :);
costFluorTrials = mouseFluorTrials(costIdx, :);
