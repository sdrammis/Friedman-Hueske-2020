function heights = get_spike_heights(twdb, mouse, period, eng, useFirstTask)
TONE_DURATION = 2000;
SPIKE_GRADE_THRESH = 0.55;
SPIKE_PEAK_IDX = 51;

sessionIdxs = get_mouse_sessions(twdb, mouse.ID, useFirstTask, 0, 'all', 0);
sessions = twdb(sessionIdxs);
[~, sortOrder] = sort({sessions.sessionDate});
sessions = sessions(sortOrder);

firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouse.ID));
if strcmp(firstSessionType, 'tt')
    if useFirstTask
        rewardTone = 1;
    else
        rewardTone = 2;
    end
else
    if useFirstTask
        rewardTone = 2;
    else
        rewardTone = 1;
    end
end

n = size(sessions,2);
heights = nan(1,n);
for ii=1:n
    trialData_ = sessions(ii).trialData;
    if isempty(trialData_)
        continue;
    end
    
    trialData_.trialIDX = (1:height(trialData_))';
    trialSpikes_ = sessions(ii).trialSpikes;
    if isempty(trialSpikes_) || ~ismember('Engagement', trialData_.Properties.VariableNames)
        continue;
    end
    
    session470 = sessions(ii).raw470Session;
    session405 = sessions(ii).raw405Session;
    try
        extractedSpikes = process_session(...
            session470(:,1), session470(:,2), session405(:,1), session405(:,2));
    catch
        continue;
    end
    % NOTE - peaks are located at index 51 in extractedSpikes{:,7} (470
    % filtered and smoothed)
    
    if ~strcmp(eng, 'all')
        engIDXs = find(trialData_.Engagement == eng);
        trialData = trialData_(engIDXs,:);
        trialSpikes = trialSpikes_(ismember(trialSpikes_.trialIDX, engIDXs),:);
        if isempty(trialSpikes)
            continue;
        end
    else
        trialData = trialData_;
        trialSpikes = trialSpikes_;
    end
    
    switch period
        case 'all'
            s = trialData.TrialStartTime;
            t = trialData.ITIEndTime;
        case 'tone'
            s = trialData.ToneStartTime;
            t = trialData.ToneStartTime + TONE_DURATION;
        case 'response'
            s = trialData.ToneStartTime + TONE_DURATION;
            t = trialData.OutcomeStartTime;
        case 'outcome+ITI'
            s = trialData.OutcomeStartTime;
            t = trialData.OutcomeStartTime + TONE_DURATION * 5;
    end
    
    spikeHeights = [];
    for jj=1:height(trialData)
        spikes = trialSpikes(trialSpikes.trialIDX == trialData.trialIDX(jj),:);
        if trialData.StimulusID(jj) ~= rewardTone || isempty(spikes)
            continue;
        end
        
        cleanSpikes = spikes(spikes.Grade >= SPIKE_GRADE_THRESH, :);
        periodSpikes = cleanSpikes(cleanSpikes.PeakTime >= s(jj) & cleanSpikes.PeakTime <= t(jj),:);
        for k=1:size(periodSpikes,1)
           spike = periodSpikes(k,:);
           spikeTrace = extractedSpikes{spike.StartTime == [extractedSpikes{:,1}],7};
           spikeHeights = [spikeHeights spikeTrace(SPIKE_PEAK_IDX)];
        end
    end
    heights(ii) = nanmean(spikeHeights);
end
end