function sessionIdxs = get_sessions(twdb, mouse, task)
sessionIdxs = [];

firstTask = mouse.firstSessionType;
if isempty(firstTask)
    return;
end

sessionLast = [];
if task == 1
    task = firstTask;
    sessionLast = mouse.learnedFirstTaskSessions;
else
    task = tern(strcmp(firstTask, 'tt'), 't2r', 'tt');
    sessionLast = mouse.learnedReversalTaskSessions;
end


sessionIdxs = twdb_lookup(twdb, 'index', 'key', ...
    'mouseID', mouse.ID, 'key', 'taskType', task);
if sessionLast == -1
    devaluation = {twdb(cell2mat(sessionIdxs)).devaluation};
    sessionLast = find(~cellfun(@isempty, devaluation));
    if isempty(sessionLast)
        return;
    end
    
    sessionIdxs = sessionIdxs(1:sessionLast);
end
end

