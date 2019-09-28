STRIO_MASKS_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMAGES_PATH = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
OUT_FILE_STRIO = './msn_density_strio.csv';
OUT_FILE_MATRIX = './msn_density_matrix.csv';

fileStrioID = fopen(OUT_FILE_STRIO, 'a');
fileMatrixID = fopen(OUT_FILE_MATRIX, 'a');

load('../dbs/miceType.mat');
jsonDB = jsondecode(fileread('../dbs/db.json'));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

fileObjs = dir([STRIO_MASKS_PATH '/*-done.txt']);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    filename = fileObjs(i).name;
    if ~contains(filename, {'exp1', 'exp2', 'exp3', 'exp4', 'exp5', 'exp6'})
        continue;
    end
    
    fprintf(['Running ' filename '... \n']);
    
    exid = regexprep(filename, '-done.txt', '');
    experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
    if isempty(experiment)
        fprintf(['... no experiment found for slice ...' filename '\n']);
        continue;
    end
    experiment = experiment{1};
    slice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
    slice = slice{1};
    
    imgStrio = img_read_visible([IMAGES_PATH '/' experiment '/' slice '_strio.tiff']);
    imgMSN = imread([IMAGES_PATH '/' experiment '/' slice '_msn.tiff']);
    masksStrio = load([STRIO_MASKS_PATH '/' exid '-masks.mat']);
    threshsStrio = jsondecode(fileread([STRIO_MASKS_PATH '/' exid '-threshs.json']));
    
    try
        [strioT, matrixT] = msn_density_run_slice(imgStrio, imgMSN, masksStrio, threshsStrio, 2);
        strioData = table2cell(strioT);
        matrixData = table2cell(matrixT);
        fprintf(fileStrioID, '%d, %d, %d, %d, %d, %d, %d \n', strioData{1}, ...
            strioData{2}, strioData{3}, strioData{4}, ...
            strioData{5}, strioData{6}, strioData{7});
        fprintf(fileMatrixID, '%d, %d, %d, %d, %d, %d, %d \n', matrixData{1}, ...
            matrixData{2}, matrixData{3}, matrixData{4}, ...
            matrixData{5}, matrixData{6}, matrixData{7});
    catch
        fprintf(['ERROR running slice ' filename '\n']);
    end
end
fclose(fileStrioID);
fclose(fileMatrixID);
