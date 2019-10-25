function [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone)
 
 
rewardIdx = mouseTrials.StimulusID == rewardTone;
costIdx = mouseTrials.StimulusID == costTone;
rewardTrials = mouseTrials(rewardIdx,:);
costTrials = mouseTrials(costIdx,:);
if ~isempty(mouseFluorTrials)
    rewardFluorTrials = mouseFluorTrials(rewardIdx,:);
    costFluorTrials = mouseFluorTrials(costIdx,:);
end