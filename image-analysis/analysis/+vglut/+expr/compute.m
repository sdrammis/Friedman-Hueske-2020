% Computes the overall VGlut expression, removing fibers of passage.
DIM_PTH = './dbs/dimensions.mat';
DB_PTH = './dbs/db.json';
STRIO_MASKS_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMAGES_PATH = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
OUT_DIR = '/annex4/afried/resultfiles/analysis_output/vglut';

% Load dependencies.
addpath(genpath('./lib'))
excsM = utils.dbload(DB_PTH);

% Create output file
datefmt = 'YYmmdd_HHMMSS';
fileID = fopen([OUT_DIR '/vglut-data_' datestr(datetime('now'), datefmt)  '.txt'], 'a');

% Find the Strio masks that have been completed.
files = dir([STRIO_MASKS_PATH '/*-done.txt']);
nFiles = length(files);
if nFiles == 0
    return;
end

for iFile=1:nFiles
    filename = files(iFile).name;
    
    % VGlut stain only occured in the following validExps.
    validExps = 'exp1|exp2|exp3|exp4|exp5|exp6|vglut';
    if isempty(regexp(filename, validExps, 'ONCE'))
        continue;
    end
    
    exid = regexprep(filename, '-done.txt', '');
    fprintf('Working on execution %s... (%d / %d) \n', exid, iFile, nFiles);
    
    % Get the experiment name and slice number for the execution ID.
    experiment = twdb_lookup(excsM, 'experiment', 'key', 'exid', exid);
    if isempty(experiment)
        fprintf(['... no experiment found for exid ...' exid '\n']);
        continue;
    end
    experiment = experiment{1};
    slce = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
    slce = slce{1};
    
    % Find the real dimension of the slice im mm2.
    w = dimensions.width(lower(dimensions.slice) == slce);
    h = dimensions.height(lower(dimensions.slice) == slce);
    realsize = (w * h);
    
    % Compute the VGlut expression present in the slice.
    strioPth = [IMAGES_PATH '/' experiment '/' lower(slice) '_strio.tiff'];
    vglutPth = [IMAGES_PATH '/' experiment '/' slice '_vglut.tiff'];
    masksPth = [STRIO_MASKS_PATH '/' exid '-masks.mat'];
    thrshsPth = [STRIO_MASKS_PATH '/' exid '-threshs.json'];
    [exprStrio, exprMatrix] = ...
        vglut.expr.computeslice(vglutPth, strioPth, masksPth, thrshsPth, realsize);
    
    % TODO get mouseID
    fprintf(fileID, '%s, %s, %d, %d \n', mouseID, slce, exprStrio, exprMatrix);
end

