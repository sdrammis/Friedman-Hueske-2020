function [mean_CDF1, mean_CDF2] = mouseCDF(twdb,mouseID,taskReversal,engaged,wantedSessions,reverse)

sessions = get_mouse_sessions(twdb,mouseID,~taskReversal,0,wantedSessions,reverse);

for session = 1:length(sessions)
    trialData = twdb(sessions(session)).trialData;
    rewardTone = twdb(sessions(session)).rewardTone;
    costTone = twdb(sessions(session)).costTone;
    tone1_cdf = toneCDF(trialData,rewardTone,engaged);
    tone2_cdf = toneCDF(trialData,costTone,engaged);

    CDF1(session,1:length(tone1_cdf)) = tone1_cdf;
    CDF2(session,1:length(tone2_cdf)) = tone2_cdf;
end

mean_CDF1 = nanmean(CDF1,1);
mean_CDF2 = nanmean(CDF2,1);

