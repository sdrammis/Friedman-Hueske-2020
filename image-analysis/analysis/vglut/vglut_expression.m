load('./dbs/dimensions.mat');

jsonDB = jsondecode(fileread('./dbs/db.json'));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

learnedWT = utils.get_mice(miceType, 'health', "WT", 'learned');
nlearnedWT = utils.get_mice(miceType, 'health', "WT", 'not-learned');
nlearnedHD = utils.get_mice(miceType, 'health', "HD", 'not-learned');

fprintf('Running LWT... \n');
writetable(get_activity(learnedWT, imagesMap, dimensions), 'exprLWT.csv');
fprintf('Running NLWT... \n');
writetable(get_activity(nlearnedWT, imagesMap, dimensions), 'exprNLWT.csv');
fprintf('Running NLHD... \n');
writetable(get_activity(nlearnedHD, imagesMap, dimensions), 'exprNLHD.csv');

function expr = get_activity(mice, imagesMap, dimensions)
miceIDs = {mice(:).ID};
exprCells = cellfun(@(mouseID) get_expression(mouseID, imagesMap, dimensions), miceIDs, 'UniformOutput', false);
exprRaw = horzcat(exprCells{:});
expr = cell2table(vertcat(exprRaw{:}), 'Variablenames', {'slice', 'strio', 'matrix', 'strioWithFibers', 'matrixWithFibers', 'strioSize'});
end

function expr = get_expression(mouseID, imagesMap, dimensions)
STRIO_MASKS_PATH = '/Volumes/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMAGES_PATH = '/Volumes/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';

expr = {};

fileObjs = dir([STRIO_MASKS_PATH '/' sprintf('*_%s_*-done.txt', mouseID)]);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    filename = fileObjs(i).name;
%     if ~contains(filename, {'exp1', 'exp2', 'exp3', 'exp4', 'exp5', 'exp6'})
%         continue;
%     end
    if ~contains(filename, {'vglut'})
       continue; 
    end
        
    exid = regexprep(filename, '-done.txt', '');
    fprintf(['Working on exid...' exid '\n']);

    experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
    if isempty(experiment)
        fprintf(['... no experiment found for slice ...' filename '\n']);
        continue;
    end
    experiment = experiment{1};
    slice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
    slice = slice{1};
    
    dim = -1;
    for j=1:height(dimensions)
        if strcmpi(dimensions.slice(j), slice)
            dim = dimensions.width(j) * dimensions.height(j);
            break;
        end
    end
    if dim == -1
        fprintf(['... no dimension found for slice ...' filename '\n']);
        continue;
    end
    
    strioPth = [IMAGES_PATH '/' experiment '/' lower(slice) '_strio.tiff'];
    vglutPth = [IMAGES_PATH '/' experiment '/' slice '_vglut.tiff'];
    masksPth = [STRIO_MASKS_PATH '/' exid '-masks.mat'];
    thrshsPth = [STRIO_MASKS_PATH '/' exid '-threshs.json'];
    
    try
        [exprStrio, exprMatrix, exprStrioWithFibers, exprMatrixWithFibers, strioSize] = ...
            vglut_get_slice_expression(vglutPth, strioPth, masksPth, thrshsPth, dim);
        expr{end+1} = {slice, exprStrio, exprMatrix, exprStrioWithFibers, exprMatrixWithFibers, strioSize};
    catch me
        disp(getReport( me, 'extended', 'hyperlinks', 'on' ))
        continue;
    end
end
end
