function [ Etrials, Ntrials, Utrials ] = splitByStates3( trials, states,rewardTone )
% splitByStates
% INPUT:
% trials - table of tr
statesIDX = 1;
prevTrialState = 2;


Ntrials = [];
Etrials = [];
Utrials = [];
for v = 1:height(trials)
    trial = trials(v, :);
    if trial.StimulusID == rewardTone
        state = states(statesIDX);
        if state == 1
            Ntrials = [Ntrials; trial];
            prevTrialState = 1;
        elseif state == 2
            Etrials = [Etrials; trial];
            prevTrialState = 2;
        else
            Utrials = [Utrials; trial];
            prevTrialState = 3;
        end
        statesIDX = statesIDX + 1;
    else
        if prevTrialState == 1
            Ntrials = [Ntrials; trial];
        elseif prevTrialState == 2
            Etrials = [Etrials; trial];
        else
            Utrials = [Utrials; trial];
        end
    end
end
end
