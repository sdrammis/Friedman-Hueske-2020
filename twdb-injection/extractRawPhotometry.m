function twdb = extractRawPhotometry(twdb)

for n = 1:length(twdb)
    eventData = twdb(n).eventData;
    raw_470_idx = eventData(:,2) == 470;
    raw_470_time = eventData(raw_470_idx,1);
    raw_470_values = eventData(raw_470_idx,3);
    raw_470_data = [raw_470_time raw_470_values];
    
    raw_405_idx = eventData(:,2) == 405;
    raw_405_time = eventData(raw_405_idx,1);
    raw_405_values = eventData(raw_405_idx,3);
    raw_405_data = [raw_405_time raw_405_values];
    
    twdb(n).raw470Session = raw_470_data;
    twdb(n).raw405Session = raw_405_data;
    
    trials = twdb(n).trials;
    
    trials_470_data = cell(length(trials),1);
    trials_405_data = cell(length(trials),1);
    for t = 1:length(trials)
        trialEventData = trials{t};
        trial_raw_470_idx = trialEventData(:,2) == 470;
        trial_raw_470_time = trialEventData(trial_raw_470_idx,1);
        trial_raw_470_values = trialEventData(trial_raw_470_idx,3);
        trial_raw_470_data = [trial_raw_470_time trial_raw_470_values];
        trials_470_data{t} = trial_raw_470_data;

        trialEventData = trials{t};
        trial_raw_405_idx = trialEventData(:,2) == 405;
        trial_raw_405_time = trialEventData(trial_raw_405_idx,1);
        trial_raw_405_values = trialEventData(trial_raw_405_idx,3);
        trial_raw_405_data = [trial_raw_405_time trial_raw_405_values];
        trials_405_data{t} = trial_raw_405_data;
    end
    twdb(n).raw470Trials = trials_470_data;
    twdb(n).raw405Trials = trials_405_data;
end
