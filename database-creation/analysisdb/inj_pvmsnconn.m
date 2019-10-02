function analysisdb = inj_pvmsnconn(analysisdb, datapath)
% Inject the results from PV->MSN analysis into the analysisdb.
% This script is idempotent.

% Load the CSV analysis results data.
opts = delimitedTextImportOptions("NumVariables", 7);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["mouseID", "dataFile", "blobs", "cellAreaPX"];
opts.VariableTypes = ["string", "string", "double", "double"];
opts = setvaropts(opts, 2, "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
conndata = readtable(datapath, opts);
clear opts

% Clear old results.
for i=1:size(analysisdb,1)
    analysisdb(i).pvmsnblobs = [];
end

% Inject zstack results into the database
for iData=1:height(conndata)
    datum = conndata(iData,:);
    
    splits = strsplit(datum.dataFile, '.');
    splits2 = strsplit(splits{1}, '_');
    slice = lower(strip(sprintf('%s_' ,splits2{1:end-2}), '_'));
    stack = splits2{end-1};
    row = findrow(analysisdb, slice, stack);
    if isempty(row)
        [analysisdb, row] = newrow(analysisdb, slice, stack, datum.mouseID);
        analysisdb(row).pvmsnblobs = []; 
    end
    analysisdb(row).pvmsnblobs(end+1) = datum.blobs;
end
end
