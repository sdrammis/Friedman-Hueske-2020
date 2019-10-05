function mouse_sessions = get_mouse_sessions(twdb,mouseID,taskType,wantedSessions,reverse)

mouse_sessions = [];
sessions = twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType);
sessionNums = [twdb([sessions{:}]).sessionNumber];

[~,I]=sort(sessionNums);
sessions = sessions(I);

if isequal(wantedSessions,'all')
    mouse_sessions = [sessions{:}];
else
    if reverse
        for n = wantedSessions
             mouse_sessions = [sessions{end-n} mouse_sessions];
        end
    else
        mouse_sessions = [mouse_sessions sessions{wantedSessions}];
    end
end