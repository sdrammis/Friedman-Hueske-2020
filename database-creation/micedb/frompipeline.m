function micedb = frompipeline(micedb, pipelinedbpath)
% Adds pipeline execution names to mice database.

pipelinedb = jsondecode(fileread(pipelinedbpath));
executions = pipelinedb.executions;

% Prepopulate the exid field. 
% Also makes the function idempotent.
for i=1:length(micedb)
    micedb(i).exids = [];
end

for i=1:length(executions)
    exid = executions(i).exid;
    
    splits = strsplit(exid, '_');
    mouseID = splits{2};    
    idx = find(strcmp(mouseID, {micedb.ID}),1);
    
    if isnan(str2double(mouseID)) || startsWith(mouseID,'0')
        warning('frompipeline: Could not insert exid %s \n', exid);
        continue;
    end
    
    if isempty(idx)
        idx = length(micedb) + 1;
        micedb(idx).ID = mouseID;
    end
    
    if isempty(micedb(idx).exids)
        micedb(idx).exids = {exid};
    else
        micedb(idx).exids{end+1} = exid;
    end
end
end