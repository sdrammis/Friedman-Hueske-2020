function trial = get_trials(twdb, sessionIdxs)
GRADE_THRESH = 0.55;

n = length(sessionIdxs);
trial.smallSpikes = cell(1,n); 
trial.bigSpikes = cell(1,n); 
trial.trialData = cell(1,n);
trial.rewardTones = zeros(1,n);

sessions = twdb(sessionIdxs);
[~, sortOrder] = sort({sessions.sessionDate});
sessions = sessions(sortOrder);

for ii=1:length(sessionIdxs)
    row = twdb(sessionIdxs(ii));
    trialSpikes = row.trialSpikes;
    if isempty(trialSpikes)
        continue;
    end
    
    varsDel = {'BurstStartTime', 'BurstNumber'};
    spikes = cellfun(@(T) removevars(T,varsDel), trialSpikes, 'UniformOutput', false);
    spikes = vertcat(spikes{:});
    goodSpikes = spikes(spikes.Grade >= GRADE_THRESH,:);
    
    trial.trialData(ii) = {row.trialData};
    trial.smallSpikes(ii) = {goodSpikes.PeakTime(goodSpikes.Group == 0)};
    trial.bigSpikes(ii) = {goodSpikes.PeakTime(goodSpikes.Group == 1)};
    trial.rewardTones(ii) = row.rewardTone;
end
end
