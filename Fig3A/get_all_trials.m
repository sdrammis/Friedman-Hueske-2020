function [mouseTrials,fluorTrials,rewardTone,costTone,numSessions] = get_all_trials(twdb,msID,idxs)
% for now, only need to get one session's trials, hence the "first" in the
% conditionals for injection
% idxs: the twdbIdxs corresponding to each mouse that you want. An array.

%     miceTrials = cell(1,length(mouseID));
    
%     for m = 1:length(miceIDs)
%         mouseID = miceIDs{m};
        
%         sessionIdx = idxs(m);
%         sessionIdx = get_mouse_sessions(twdb,mouseID,injection,concentration,'all',0);
%         if strcmp(injection,'Saline Before')
%             sessionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,...
%                 'key','injection','Diazepam')) - 1;
%         elseif strcmp(injection,'Saline After')
%             sessionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,...
%                 'key','injection','Diazepam')) + 1;
%         elseif strcmp(injection,'Diazepam')
%             sessionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,...
%                 'key','injection',injection));
%         else % assume the input is the sessionIdx in twdb (e.g. 7265)
%             sessionIdx = injection;
%         end
        mouseID = msID{1};
        mouseTrials = table;
        fluorTrials = [];
        for n = 1:length(idxs)
            idx = idxs(n);
            trialData = twdb(idx).trialData;
            if isempty(trialData)
                continue
            end
            mouseTrials = [mouseTrials; trialData(:,1:8)];
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
        end

%         if upToLearned
%             if ~reversal
%                 learnedFirstTask = first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', mouseID));
%                 if learnedFirstTask ~= -1
%                     mouseTrials = mouseTrials(1:learnedFirstTask,:);
%                     fluorTrials = fluorTrials(1:learnedFirstTask,:);
%                 end
%             else
%                 learnedReversalTask = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', mouseID));
%                 if learnedReversalTask ~= -1
%                     mouseTrials = mouseTrials(1:learnedReversalTask,:);
%                     fluorTrials = fluorTrials(1:learnedReversalTask,:);
%                 end
%             end
%         end
        
%         miceTrials{m} = mouseTrials;
%         miceFluorTrials{m} = fluorTrials;
%         rewardTones(m) = twdb(idx).rewardTone;
%         costTones(m) = twdb(idx).costTone;
        rewardTone = twdb(idx).rewardTone;
        costTone = twdb(idx).costTone;
        numSessions = length(idxs); % originally numSessions(m) = length(sessionIdx)
%     end
end

function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end