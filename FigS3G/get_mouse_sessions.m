function mouse_sessions = get_mouse_sessions(twdb,mouseID,injection,concentration,wantedSessions,reverse)
    
%     firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouseID));
%     if ~firstTaskType
%         if isequal(firstSessionType,'tt')
%             taskType = '2tr';
%         elseif isequal(firstSessionType,'2tr')
%             taskType = 'tt';
%         end
%     else
%         taskType = firstSessionType;
%     end
    
    mouse_sessions = [];
    sessions_idx = twdb_lookup(twdb,'index','key','mouseID',mouseID,...
        'key','injection',injection,'key','concentration',concentration);
    sessionNums = [twdb([sessions_idx{:}]).sessionNumber];

    [sessionNums,I]=sort(sessionNums);
    sessions_idx = sessions_idx(I);

    if isequal(wantedSessions,'all')
        wantedSessions = sessionNums;
    end

    if reverse
        for n = wantedSessions
             mouse_sessions = [sessions_idx{end-n} mouse_sessions];
        end
    else
        mouse_sessions = [sessions_idx{wantedSessions}];
    end


%     if ~devaluation %don't include sessions after devaluation
%         waterDeval_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','WaterDevaluation',1));
%         sucroseDeval_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','SucroseDevaluation',1));
%         firstDeval_sessionNum = min([waterDeval_sessionNum,sucroseDeval_sessionNum]);
%         if ~isempty(firstDeval_sessionNum)
%             mouse_sessions = mouse_sessions(wantedSessions < firstDeval_sessionNum);
%         end
%     end
end