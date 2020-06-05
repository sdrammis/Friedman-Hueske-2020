function mouse_sessions = getInjectionSessions(twdb,mouseID,injectionType,concentration,firstTaskType,wantedSessions,reverse,deval)

    firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouseID));
    if ~firstTaskType
        if isequal(firstSessionType,'tt')
            taskType = '2tr';
        elseif isequal(firstSessionType,'2tr')
            taskType = 'tt';
        end
    else
        taskType = firstSessionType;
    end
    
    mouse_sessions = [];
    if ~isequal(concentration,'all')
        sessions_idx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType,'key','injection',injectionType,'key','concentration',concentration));
    else
        sessions_idx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType,'key','injection',injectionType));
    end
    
    if isempty(sessions_idx)
        mouse_sessions = NaN;
        return
    end
    
    if ~isequal(deval,'all')
        water_idx = cell2mat(twdb_lookup(twdb(sessions_idx),'index','key','devaluation','Water'));
        sucrose_idx = cell2mat(twdb_lookup(twdb(sessions_idx),'index','key','devaluation','Sucrose'));
        if ~deval
            deval_idx = [water_idx sucrose_idx];
            sessions_idx = setdiff(sessions_idx,deval_idx);
        elseif isequal(deval,'Water')
            sessions_idx = water_idx;
        elseif isequal(deval,'Sucrose')
            sessions_idx = sucrose_idx;
        end
    end
    sessionNums = [twdb(sessions_idx).sessionNumber];

    [~,I]=sort(sessionNums);
    sessions_idx = sessions_idx(I);

    if isequal(wantedSessions,'all')
        wantedSessions = 1:length(sessions_idx);
    end

    if reverse
        for n = wantedSessions
             mouse_sessions = [sessions_idx(end-n) mouse_sessions];
        end
    else
        mouse_sessions = sessions_idx(wantedSessions);
    end
end