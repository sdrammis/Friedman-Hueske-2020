function row = findrow(analysisdb, slice, stack)
if ~isfield(analysisdb, 'slice')
    throw(MException('getrow:emptystruct', 'analysisdb is an empty struct.'));
end

row = find(strcmp(slice, {analysisdb.slice}) & strcmp(stack, {analysisdb.stack}));
end

