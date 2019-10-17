function [miceTrials,rewardTones,costTones,numSessions] = get_mouse_trials(twdb,miceIDs,upToLearned,reversal)
    
    miceTrials = cell(1,length(miceIDs));
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        sessionIdx = get_mouse_sessions(twdb,mouseID,~reversal,1,'all',0);
        if ~isempty(sessionIdx)
            mouseTrials = table;
            for idx = sessionIdx
                trialData = twdb(idx).trialData;
                if isempty(trialData)
                    continue
                end
                if ~any(strcmp('Engagement', trialData.Properties.VariableNames))
                    trialData.Engagement = -1*ones(height(trialData),1);
                end
                trialData.SessionNumber = twdb(idx).sessionNumber*ones(height(trialData),1);
                mouseTrials = [mouseTrials; trialData];
            end

            if upToLearned
                if ~reversal
                    learnedFirstTask = first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', mouseID));
                    if learnedFirstTask ~= -1
                        mouseTrials = mouseTrials(1:learnedFirstTask,:);
                    end
                else
                    learnedReversalTask = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', mouseID));
                    if learnedReversalTask ~= -1
                        mouseTrials = mouseTrials(1:learnedReversalTask,:);
                    end
                end
            end

            miceTrials{m} = mouseTrials;
            rewardTones(m) = twdb(idx).rewardTone;
            costTones(m) = twdb(idx).costTone;
            numSessions(m) = length(sessionIdx);

        else
            miceTrials{m} = -1;
            rewardTones(m) = -1;
            costTones(m) = -1;
            sessionNumbers(m) = 0;
        end
    end
end