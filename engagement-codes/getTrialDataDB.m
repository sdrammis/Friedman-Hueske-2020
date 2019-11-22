function trialDataDB = getTrialDataDB(twdb,firstTask)

exceptions = {};
miceIDs = get_mouse_ids(twdb,~firstTask,'all','all','all','all','all','all',exceptions);

n = 1;
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    mouseTrials = table;
    sessions_idx = get_mouse_sessions(twdb,mouseID,firstTask,0,'all',0);
    for idx = sessions_idx
        sessionNumber = twdb_lookup(twdb, 'sessionNumber', 'key', 'index', idx);
        trialData = twdb(idx).trialData;
        if ~isempty(trialData)
            trialData.ReactionTime = [];
            trialData.LengthOfITI = [];
            trialData.ResponseILI = [];
            trialData.OutcomeILI = [];
            trialData.TrialStartTime = [];
            trialData.ToneStartTime = [];
            trialData.ResponseStartTime = [];
            trialData.OutcomeStartTime = [];
            trialData.OutcomeEndTime = [];
            trialData.ITIEndTime = [];
            trialData.SessionFilename = [];
            trialData.SessionNumber = ones(height(trialData), 1) * sessionNumber{1};
            mouseTrials = [mouseTrials; trialData];
        end
    end
    if ~isempty(sessions_idx)
        trialDataDB(n).mouseID = mouseID;
        trialDataDB(n).trialData = mouseTrials;
        trialDataDB(n).rewardTone = twdb(idx).rewardTone;
        n = n+1;
    end
end