conf = msnspines.v2.config('local');
disp(conf)
addpath(genpath('./lib'));

outPath = [conf.OUT_DIR '/msnspines_data_' datestr(now,'mmddyy_HH-MM') '.csv'];
outFileID = fopen(outPath, 'a');

jsonDB = jsondecode(fileread(conf.DB_PATH));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

load(conf.DIMS_PATH); % Required for finding dendrites' real lengths.

dirContents = dir(conf.DATA_DIR_DONE);
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
    
    imsrc = [conf.IMGS_DIR '/' experiment '/' slice '_msn.tiff'];
    
    fprintf('Running execution %s ... \n', exid);
    try
        [dendLengths, numSpines] = ...
            msnspines.v2.spineCounter(exid, imsrc, realsize);
        for k = 1:length(dendLengths)
            fprintf(outFileID, '%s, %d, %.6f, %d\n', ...
                exid, k, dendLengths(k), numSpines(k));
        end
    catch
        fprintf('ERROR: Failed to run execution %s \n', exid);
        continue;
    end
end
fclose(outFileID);
