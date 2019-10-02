function analysisdb = create(dbfile)
analysisdb = struct();

pipelinedb = jsondecode(fileread(dbfile));
executions = pipelinedb.executions;
nExs = length(executions);

for iExs=1:nExs
    execution = executions(iExs);
    
    splits = strsplit(execution.exid, '_');
    mouseID = splits{2};
    if isnan(str2double(mouseID)) || startsWith(mouseID,'0') % Wrongly named execution.
        continue;
    end
    
    slice = lower(execution.slice);
    idx = 0;
    try
        row = findrow(analysisdb, slice, 'P');
        if ~isempty(row)
            continue;
        end
        idx = length(analysisdb) + 1;
    catch ME
        if strcmp(ME.identifier,'getrow:emptystruct')
            idx = 1;
        else
            rethrow(ME)
        end  
    end
    analysisdb(idx).ID = idx;
    analysisdb(idx).slice = slice;
    analysisdb(idx).stack = 'P';
    analysisdb(idx).mouseID = mouseID;
end
end

