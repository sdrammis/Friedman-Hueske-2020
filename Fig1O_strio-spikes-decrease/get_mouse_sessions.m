function mouse_sessions = get_mouse_sessions(twdb,mouseID,firstTaskType,specialSessions,wantedSessions,reverse)
mouse_sessions = [];

firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouseID));
if isempty(firstSessionType)
    return;
end

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
sessions_idx = twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType);
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


if ~specialSessions %don't include sessions after devaluation
    waterDeval_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','devaluation','Water'));
    sucroseDeval_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','devaluation','Sucrose'));
    cnoInjection_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','injection','CNO'));
    cnoApomorphineInjection_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','injection','CNO + Apomorphine'));
    apomorphineInjection_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','injection','Apomorphine'));
    salineInjection_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','injection','Saline'));
    diazepamInjection_sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',mouseID,'key','taskType',taskType,'key','injection','Diazepam'));
    firstSpecial_sessionNum = min([waterDeval_sessionNum,sucroseDeval_sessionNum,cnoInjection_sessionNum,cnoApomorphineInjection_sessionNum,apomorphineInjection_sessionNum,salineInjection_sessionNum,diazepamInjection_sessionNum]);
    if ~isempty(firstSpecial_sessionNum)
        mouse_sessions = mouse_sessions(wantedSessions < firstSpecial_sessionNum);
    end
end
end

function ret = first(x)
ret = [];

if ~isempty(x)
    ret = x{1};
end
end
