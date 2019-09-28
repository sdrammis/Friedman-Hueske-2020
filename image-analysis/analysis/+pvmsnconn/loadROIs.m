function ROIs = loadROIs(xlsxFile)
Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:E42";
opts.VariableNames = ["Name", "X1", "Y1", "X2", "Y2"];
opts.SelectedVariableNames = ["Name", "X1", "Y1", "X2", "Y2"];
opts.VariableTypes = ["string", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");
ROIs = readtable(xlsxFile, opts, "UseExcel", false);
clear opts
end
