function mouse = findmouse(micedb, exid)
mouse = [];

splits = strsplit(exid, '_');
mouseID = splits{2};
if isnan(str2double(mouseID))
    return;
end

idx = find(strcmp(mouseID, {micedb.ID}));
if isempty(idx)
    return;
end
mouse = micedb(idx);
end

