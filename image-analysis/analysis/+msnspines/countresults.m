DATA_DIR = '/annex4/afried/resultfiles/system-tree/msn_dendrites_spines_detection/done';
OUT_DIR = '/annex4/afried/resultfiles/analysis_output/msn_dends_spines';
DB_PATH = '/annex4/afried/resultfiles/system-tree/db.json';
DIMS_PATH = './dbs/dimensions.mat';

jsonDB = jsondecode(fileread(DB_PATH));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

addpath(genpath('./lib'));
load(DIMS_PATH); % Required for finding dendrites' real lengths.

outPath = [OUT_DIR '/data_' datestr(now,'mmddyy_HH-MM') '.csv'];
outFileID = fopen(outPath, 'a');

dirContents = dir(DATA_DIR);
files = {dirContents(:).name};
executions = erase(files(contains(files, 'done.txt')), '-done.txt');
for i=1:length(executions)
    exid = executions{i};
    
    experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
    experiment = experiment{1};
    slice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
    slice = slice{1};
    
    width = dimensions.width(lower(dimensions.slice) == lower(slice));
    height = dimensions.height(lower(dimensions.slice) == lower(slice));
    if isempty(width) || isempty(height)
        continue;
    end
    realsize = width * height;
    
    fprintf('Running execution %s ... \n', exid);
    try
        [dendAreaMM2, numDendPx, dendLength, numSpines] = ...
            msnspines.countexid(DATA_DIR, exid, realsize);
        fprintf(outFileID, '%s, %.6f, %d, %.6f, %d \n', ...
            exid, dendAreaMM2, numDendPx, dendLength, numSpines);
    catch
        fprintf('ERROR: Failed to run execution %s \n', exid);
        continue;
    end
end
fclose(fileID);
