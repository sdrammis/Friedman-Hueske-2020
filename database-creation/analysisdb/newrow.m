function [analysisdb, idx] = newrow(analysisdb, slice, stack, mouseID)
if ~isfield(analysisdb, 'slice')
    throw(MException('getrow:emptystruct', 'analysisdb is an empty struct.'));
end

idx = length(analysisdb) + 1;
analysisdb(idx).ID = idx;
analysisdb(idx).slice = char(slice);
analysisdb(idx).stack = char(stack);
analysisdb(idx).mouseID = char(mouseID);
end