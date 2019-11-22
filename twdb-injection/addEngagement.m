function twdb = addEngagement(twdb,firstTaskType,engagementDir)

engagement_files = dir(engagementDir);
for f = 1:length(engagement_files)
    if realFile(engagement_files(f).name)
        filename = engagement_files(f).name;
        fileParts = strsplit(filename,'-');
        mouseID = fileParts{2}
        load(fullfile(engagementDir,filename))
        sessionNumbers = unique([trials.SessionNumber]);
        for sessionNumber = sessionNumbers
            sessionTrials_idx = [trials.SessionNumber] == sessionNumber;
            trial_idx = [trials(sessionTrials_idx).IDXofTrial];
            session_engagement = [trials(sessionTrials_idx).Engagement];
            session_engagement(session_engagement == -1) = 1;
            session_idx = get_mouse_sessions(twdb,mouseID,firstTaskType,0,sessionNumber,0);
            trialData = twdb(session_idx).trialData;
            trialData.Engagement = zeros(height(trialData),1);
            trialData.Engagement(trial_idx) = session_engagement;
            twdb(session_idx).trialData = trialData;
        end
    end
end