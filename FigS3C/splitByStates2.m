function [ Etrials, Ntrials ] = splitByStates2( trials, states )

statesIDX = 1;
prevTrialState = 2;

Ntrials = [];
Etrials = [];
for v = 1:size(trials, 1)
    if trials(v,:).StimulusID == 1
        if states(statesIDX) == 1
            
            Ntrials = [Ntrials; trials(v, :)];
            prevTrialState = 1;
            
        else
            Etrials = [Etrials; trials(v, :)];
            prevTrialState = 2;
            
        end
        statesIDX = statesIDX + 1;
    elseif trials(v,:).StimulusID == 2
        if prevTrialState == 1
            Ntrials = [Ntrials; trials(v, :)];
        else
            Etrials = [Etrials; trials(v, :)];
        end
    end
end
end