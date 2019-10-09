function analysisdb = inj_densitiescc(analysisdb, datapth)
% Import data from csv file
opts = delimitedTextImportOptions("NumVariables", 31);
opts.DataLines = [1, Inf];
opts.Delimiter = ", ";
opts.VariableNames = ["mouseID", "slice", "stack", "callS", "ctopleft", "ctopmidS", "ctopright", "cbotleftS", "cbotmidS", "cbotrightS", "callM", "ctopleftM", "ctopmidM", "ctoprightM", "cbotLeftM", "cbotmidM", "cbotrightM", "aallS", "atopleftS", "atopmidS", "atoprightS", "abotleftS", "abotmidS", "abotrightS", "aallM", "atopleftM", "atopmidM", "atoprightM", "abotleftM", "abotmidM", "abotrightM"];
opts.VariableTypes = ["double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 2, "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
counts = readtable(datapth, opts);
clear opts

% Reset current values.
for i=1:size(analysisdb,1)
    analysisdb(i).msncounts = [];
end

% Inject new values
for iData=1:height(counts)
   datum = counts(iData,:);
   slice = lower(datum.slice);
   stack = num2str(datum.stack);
   mouseID = num2str(datum.mouseID);
   
   row = findrow(analysisdb, slice, stack);
   if isempty(row)
        [analysisdb, row] = newrow(analysisdb, slice, stack, mouseID);
        analysisdb(row).msncounts = [];
   end
   analysisdb(row).msncounts = datum(1,4:end);
end
end
