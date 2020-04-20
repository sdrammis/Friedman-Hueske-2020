function [nSpikes, sessionTime, sessions, spikesGrades] = get_mouse_spikes(twdb, mouseID)
INJECTIONS = {'CNO', 'Saline', 'Apomorphine', 'CNO + Apomorphine'};
SPIKE_GRADE_THRESH = 0.55;

idxsCNO = get_injection_sessions(twdb, mouseID, INJECTIONS{1}, 'all', 1, 'all', 0, 'all');
idxsSaline = get_injection_sessions(twdb, mouseID, INJECTIONS{2}, 'all', 1, 'all', 0, 'all');
idxsApo = get_injection_sessions(twdb, mouseID, INJECTIONS{3}, 'all', 1, 'all', 0, 'all');
idxsApoCNO = get_injection_sessions(twdb, mouseID, INJECTIONS{4}, 'all', 1, 'all', 0, 'all');

idxs = sort([idxsCNO idxsSaline idxsApo idxsApoCNO]);
idxs = idxs(~isnan(idxs));
sessions = twdb(idxs);
[~, sortOrder] = sort({sessions.sessionDate});
sessions = sessions(sortOrder);

firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouseID));
if strcmp(firstSessionType, 'tt')
    rewardTone = 1;
else
    rewardTone = 2;
end

n = size(sessions,2);
nSpikes = nan(1,n);
sessionTime = nan(1,n);
spikesGrades = cell(1,n);
for ii=1:n
    trialData = sessions(ii).trialData;
    trialSpikes = sessions(ii).trialSpikes;
    if isempty(trialSpikes)
        continue;
    end
    
    spikes = [];
    for jj=1:size(trialSpikes,1)
        trialSpikes_ = trialSpikes(trialSpikes.trialIDX == jj,:);
        if isempty(trialSpikes_) || trialData{jj, 'StimulusID'} ~= rewardTone
            continue;
        end
        spikes = [spikes; trialSpikes_];
    end
    goodSpikes = spikes(spikes.Grade >= SPIKE_GRADE_THRESH, :);
    nSpikes(ii) = size(goodSpikes,1);
    sessionTime(ii) = sum(trialData.ITIEndTime - trialData.TrialStartTime);
    spikesGrades{ii} = goodSpikes.Grade;
end
end
