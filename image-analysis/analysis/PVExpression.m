jsonDB = jsondecode(fileread('./dbs/db.json'));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

learnedWT = get_mice(miceType, 'health', 'WT', 'learned');
nlearnedWT = get_mice(miceType, 'health', 'WT', 'not-learned');
nlearnedHD = get_mice(miceType, 'health', 'HD', 'not-learned');

exprLWT = get_slice_expression(learnedWT, imagesMap);
exprNLWT = get_slice_expression(nlearnedWT, imagesMap);
exprNLHD = get_slice_expression(nlearnedHD, imagesMap);

function expr = get_slice_expression(mice, imagesMap)
miceIDs = {mice(:).ID};
exprCells = cellfun(@(mouseID) get_expression(mouseID, imagesMap), miceIDs, 'UniformOutput', false);
expr = horzcat(exprCells{:});
end

function expr = get_expression(mouseID, imagesMap)
CELLS_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/done';
IMAGES_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';

expr = [];

fileObjs = dir([CELLS_PATH '/' sprintf('*_%s_*-data.mat', mouseID)]);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    filename = fileObjs(i).name;
    if ~contains(filename, {'exp7', 'exp8', 'exp9'})
        continue;
    end
    
    % exclude following because of artifacts
%     if contains(filename, {'2703_slice2', '2712_slice1', '2778_slice1'})
%         continue;
%     end
    
    try
        exid = regexprep(filename, '-data.mat', '');
        experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
        experiment = experiment{1};
        slice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
        slice = slice{1};

        img = imread([IMAGES_PATH '/' experiment '/' slice '_pv.tiff']);
        cells = load([CELLS_PATH '/' filename]);
        
        [~, ~, ~, point1, point2] = split_quadrants(cells.striatumMask);
    catch
        continue;
    end
    
    % TODO zscore images
    cellBodies = logical(cells.cells);
    
    
    imgKeep = img;
    imgKeep = typecast(imgKeep, 'int16');
    imgKeep(cellBodies) = -1;
    imgKeep(~cells.striatumMask) = -1;
    
    maskKeep = cells.striatumMask;
    maskKeep = typecast(maskKeep, 'int16');
    maskKeep(cellBodies) = -1;
    
    centralImgKeep = imgKeep(:,point1+1:point2);
    centralMaskKeep = maskKeep(:,point1+1:point2);
    centralImgArr = reshape(centralImgKeep.',1,[]);
    centralMaskArr = reshape(centralMaskKeep.',1,[]);
    
    centralExprNum = sum(centralImgArr(centralImgArr ~= -1));
    centralMaskNum = sum(centralMaskArr(centralMaskArr ~= -1));
    
    expr = [expr {h.Values}];
end
end