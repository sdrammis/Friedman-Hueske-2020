function [miceTrials,rewardTones,costTones,sessionNumbers] = get_deval_sessions(twdb,miceIDs,deval)
    
    sessionNumbers = [];
    miceTrials = cell(1,length(miceIDs));
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        sessionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key',deval,1));
        if ~isempty(sessionIdx)
            mouseTrials = table;
            fluorTrials = [];
            for idx = sessionIdx
                trialData = twdb(idx).trialData;
                if ~isempty(trialData)
                    if ~any(strcmp('Engagement', trialData.Properties.VariableNames))
                        trialData.Engagement = -1*ones(height(trialData),1);
                    end
                    trialData.SessionNumber = twdb(idx).sessionNumber*ones(height(trialData),1);
                    mouseTrials = [mouseTrials; trialData];
                end
            end

            miceTrials{m} = mouseTrials;
            rewardTones(m) = twdb(idx).rewardTone;
            costTones(m) = twdb(idx).costTone;
            sessionNumbers(m) = twdb(idx).sessionNumber;
        else
            miceTrials{m} = -1;
            rewardTones(m) = -1;
            costTones(m) = -1;
            sessionNumbers(m) = 0;
        end
    end
end