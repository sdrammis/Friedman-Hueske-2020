function [miceTrials,miceFluorTrials,rewardTones,costTones,numSessions] = get_all_trials(twdb,miceIDs,upToLearned,reversal)
    
    miceTrials = cell(1,length(miceIDs));
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        disp(['------' num2str(m) ': Mouse ' mouseID '------'])
        sessionIdx = get_mouse_sessions(twdb,mouseID,~reversal,0,'all',0);
        
        mouseTrials = table;
        fluorTrials = [];
        for idx = sessionIdx
            trialData = twdb(idx).trialData;
            if isempty(trialData)
                continue
            end
            mouseTrials = [mouseTrials; trialData(:,1:12)];
            [sessFluorTrials] = get_session_fluorescence_sta(twdb, mouseID, idx, 'all', false);
            if isempty(sessFluorTrials)
                fluorTrials = [fluorTrials; nan(height(trialData),98)];
                continue;
            end
            
            sessFluorAll = get_session_fluorescence_sta(twdb, mouseID, idx, 'all', true);
            numSessionTrials = size(sessFluorTrials, 1);
            for i=1:numSessionTrials
                zSessFluor = zscore_baseline(sessFluorTrials(i, :), sessFluorAll);
                fluorTrials = [fluorTrials; zSessFluor];
            end
%             figure
%             hold on
%             plot(twdb(idx).raw405Session(:,1),twdb(idx).raw405Session(:,2),'m')
%             plot(twdb(idx).raw470Session(:,1),twdb(idx).raw470Session(:,2),'b')
%             title([mouseID,'IDX: ' num2str(idx)])
        end

        if upToLearned
            if ~reversal
                learnedFirstTask = first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', mouseID));
                if learnedFirstTask ~= -1
                    mouseTrials = mouseTrials(1:learnedFirstTask,:);
                    fluorTrials = fluorTrials(1:learnedFirstTask,:);
                end
            else
                learnedReversalTask = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', mouseID));
                if learnedReversalTask ~= -1
                    mouseTrials = mouseTrials(1:learnedReversalTask,:);
                    fluorTrials = fluorTrials(1:learnedReversalTask,:);
                end
            end
        end
        
        miceTrials{m} = mouseTrials;
        miceFluorTrials{m} = fluorTrials;
        rewardTones(m) = twdb(idx).rewardTone;
        costTones(m) = twdb(idx).costTone;
        numSessions(m) = length(sessionIdx);
    end
end

function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end