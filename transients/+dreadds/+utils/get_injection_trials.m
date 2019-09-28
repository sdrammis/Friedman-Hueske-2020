function [injection_miceTrials,injection_miceFluorTrials,saline_miceTrials,saline_miceFluorTrials,...
    rewardTones,costTones,injection_numSessions] = ...
    get_injection_trials(twdb,miceIDs,reversal,injectionType,concentration,deval)

for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    injectionSessions = getInjectionSessions(twdb,mouseID,injectionType,concentration,~reversal,'all',0,deval);
    if isnan(injectionSessions)
        injection_miceTrials{m} = table;
        injection_miceFluorTrials{m} = [];
        rewardTones(m) = NaN;
        costTones(m) = NaN;
        injection_numSessions(m) = NaN;
        saline_miceTrials{m} = table;
        saline_miceFluorTrials{m} = [];
        continue
    end
    [mouseTrials,fluorTrials,rewardTone,costTone] = behaviorAndFluorescenceData(twdb, mouseID,injectionSessions);
    
    injection_miceTrials{m} = mouseTrials;
    injection_miceFluorTrials{m} = fluorTrials;
    rewardTones(m) = rewardTone;
    costTones(m) = costTone;
    injection_numSessions(m) = length(injectionSessions);
    
    %         [saline_sessions] = getSalineSessions_performance(twdb,mouseID,reversal);
    saline_sessions = getInjectionSessions(twdb,mouseID,'Saline','all',~reversal,'all',0,0);
    
    [mouseTrials,fluorTrials] = behaviorAndFluorescenceData(twdb, mouseID,saline_sessions);
    saline_miceTrials{m} = mouseTrials;
    saline_miceFluorTrials{m} = fluorTrials;
    
end
end