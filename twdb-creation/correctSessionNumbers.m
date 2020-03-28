function twdb = correctSessionNumbers(twdb)

miceIDs = get_mouse_ids(twdb,0,'all','all','all','all','all','all',{});

for id = 1:length(miceIDs)
    mouseTasks = unique(twdb_lookup(twdb,'taskType','key','mouseID',miceIDs{id}));
    for task = 1:length(mouseTasks)
        session_idx = twdb_lookup(twdb,'index','key','mouseID',miceIDs{id},'key','taskType',mouseTasks{task});
        session_idx = [session_idx{:}]';
        date = {twdb(session_idx).sessionDate};
        spaces = cell(length(session_idx),1);
        spaces(:) = {' '};
        time = {twdb(session_idx).sessionTime};
        session_dates = datetime(cellfun(@horzcat,date',spaces,time','UniformOutput',0),'InputFormat','yyyy-MM-dd HH:mm');
        date_table = table(session_dates,session_idx);
        date_table = sortrows(date_table,'session_dates');
        ordered_sessions = table2array(date_table(:,'session_idx'));
        for session = 1:length(ordered_sessions)
            twdb(ordered_sessions(session)).sessionNumber = session;
        end
    end
end