function trials = get_trials(eventData,trialsRemoved)
%Takes event data and splits it per trial

%Trial is defined by trial_start event ID and end of ITI
trial_start = 7;
ITI_stop = 10;
trialStarts_idx = find((eventData(:,2)==trial_start)); %indexes of all instances of trial_start
ITIends_idx = find((eventData(:,2)==ITI_stop)); %indexes of all instances of ITI_stop

trials = {};

%Only collects trials that are considered good
start_count = 1;
ITI_count = 1;
trial_count = 1;
while start_count <= length(trialStarts_idx)-1 && ITI_count <= length(ITIends_idx)
    if trialStarts_idx(start_count) < ITIends_idx(ITI_count) %Trial start has to happen before ITI end
        if trialStarts_idx(start_count+1) > ITIends_idx(ITI_count) %Next trial start has to happen after ITI end of current trial
            trial = eventData(trialStarts_idx(start_count):ITIends_idx(ITI_count),:);
            if trialsRemoved
                if sum(trial(:,2)==13) && sum(trial(:,2)==9)==1%Trial is good if there is a lick (lick id = 13) and one ITI start (id = 9)
                    trials{trial_count} = trial;
                    trial_count = trial_count + 1;
                end
            else
                if sum(trial(:,2)==9)==1
                    trials{trial_count} = trial;
                    trial_count = trial_count + 1;
                end
            end
            ITI_count = ITI_count+1;
            start_count = start_count+1;
        else
            start_count = start_count+1;
        end
    else
        ITI_count = ITI_count+1;
    end
end