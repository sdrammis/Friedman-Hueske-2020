function analysisdb = inj_msnspines(analysisdb, dbpath, datapath)
% Inject the results from MSN Dendrites and Spines detection it analysisdb.
% This function is idempotent.

% Load the CSV analysis results data.
opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["exid", "k", "dendLength", "numSpines"];
opts.VariableTypes = ["categorical", "double", "double", "double"];
opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
spinesdata = readtable(datapath, opts);
clear opts

% Load the pipeline database to find slice information.
jsonDB = jsondecode(fileread(dbpath));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

% Clear old results.
for i=1:size(analysisdb,2)
    analysisdb(i).msnDendriteLength = [];
    analysisdb(i).msnNumSpines = [];
end

% Inject the projection results into the database.
for iData=1:height(spinesdata)
    datum = spinesdata(iData,:);
    slice = lower(twdb_lookup(imagesMap, 'slice', 'key', 'exid', datum.exid));
    row = findrow(analysisdb, slice, 'P');
  
    if isempty(row)
        continue;
    end
    
    analysisdb(row).msnDendriteLength(end+1) = datum.dendLength;
    analysisdb(row).msnNumSpines(end+1) = datum.numSpines;
end
end