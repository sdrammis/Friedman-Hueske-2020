function [ Etrials, Ntrials ] = splitByStates2( trials, states,rewardTone )
% splitByStates
% INPUT:
% trials - table of tr
statesIDX = 1;
prevTrialState = 2;

if rewardTone == 1
    costTone = 2;
else
    costTone = 1;
end

Ntrials = [];
Etrials = [];
for v = 1:size(trials, 1)
    if trials.StimulusID(v) == rewardTone
        if states(statesIDX) == 1
            Ntrials = [Ntrials; trials(v, :)];
            prevTrialState = 1;
        else
            Etrials = [Etrials; trials(v, :)];
            prevTrialState = 2;
        end
        statesIDX = statesIDX + 1;
    elseif trials.StimulusID(v) == costTone
        if prevTrialState == 1
            Ntrials = [Ntrials; trials(v, :)];
        else
            Etrials = [Etrials; trials(v, :)];
        end
    end
end
end
