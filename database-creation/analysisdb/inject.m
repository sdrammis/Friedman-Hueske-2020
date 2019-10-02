function analysisdb = inject(analysisdb, slice, stack, field, val)
row = analysis.utils.findrow(analysisdb, slice, stack);
analysisdb(row, field) = val;
end

