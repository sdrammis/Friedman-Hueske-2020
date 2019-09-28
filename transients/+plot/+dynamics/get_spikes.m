function spikeRates = get_spikes(twdb, mouse, period, eng, useFirstTask)
TONE_DURATION = 2000;
SPIKE_GRADE_THRESH = 0.55;

sessionIdxs = utils.get_mouse_sessions(twdb, mouse.ID, useFirstTask, 0, 'all', 0);
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
spikeRates = nan(1,n);
for ii=1:n
    trialData = sessions(ii).trialData;
    trialSpikes = sessions(ii).trialSpikes;
    if isempty(trialSpikes) || ~ismember('Engagement', trialData.Properties.VariableNames)
        continue;
    end
    
    if ~strcmp(eng, 'all')
        engIdxs = trialData.Engagement == eng;
        trialData = trialData(engIdxs,:);
        trialSpikes = trialSpikes(engIdxs);
        if isempty(trialSpikes)
            continue;
        end
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
    
    nSpikes = 0;
    nTime = 0;
    for jj=1:length(trialSpikes)
        if trialData{jj,'StimulusID'} ~= rewardTone || isempty(trialSpikes{jj})
            continue;
        end
        
        spikes = removevars(trialSpikes{jj}, {'BurstStartTime', 'BurstNumber'});
        cleanSpikes = spikes(spikes.Grade >= SPIKE_GRADE_THRESH, :);
        periodSpikes = cleanSpikes(cleanSpikes.PeakTime >= s(jj) & cleanSpikes.PeakTime <= t(jj),:);
        nSpikes = nSpikes + size(periodSpikes,1);
        nTime = nTime + (t(jj) - s(jj));
    end
    spikeRates(ii) = nSpikes / nTime;
end
end

