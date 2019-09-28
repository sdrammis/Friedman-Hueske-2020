jsonDB = jsondecode(fileread('./dbs/db.json'));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

learnedWT = get_mice(miceType, 'health', 'WT', 'learned');
nlearnedWT = get_mice(miceType, 'health', 'WT', 'not-learned');
nlearnedHD = get_mice(miceType, 'health', 'HD', 'not-learned');

dendLWT = get_slice_dendrites(learnedWT, imagesMap);
dendNLWT = get_slice_dendrites(nlearnedWT, imagesMap);
dendNLHD = get_slice_dendrites(nlearnedHD, imagesMap);

function centralExpr = get_slice_dendrites(mice, imagesMap)
centralExpr = [];

miceIDs = {mice(:).ID};
expr = cellfun(@(x) get_expr(x, imagesMap), miceIDs, 'UniformOutput', false);
for i=1:length(expr)
    mouseExpr = expr{i};
    if isempty(mouseExpr)
        continue;
    end
    
    centralExpr = [centralExpr; vertcat(mouseExpr{:})];
end
end

function exprCentral = get_expr(mouseID, imagesMap)
CELLS_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/manual';
IMAGES_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';

exprCentral = [];

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
    if contains(filename, {'2703_slice2', '2712_slice1', '2778_slice1'})
        continue;
    end
    
    try
        exid = regexprep(filename, '-\d*-data.mat', '');
        experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
        experiment = experiment{1};
        slice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
        slice = slice{1};
        
        img = imread([IMAGES_PATH '/' experiment '/' slice '_pv.tiff']);
        cells = load([CELLS_PATH '/' filename]);
        
        [~, ~, ~, point1, point2] = split_quadrants(cells.striatumMask);
        
        % create mask that does not include black holes (fiber passages)
        imgKeep = img;
        imgKeep = int16(imgKeep);
        imgKeep(~cells.striatumMask) = -1;
        
        centralKeep = imgKeep(:,point1+1:point2);
        centralArr = reshape(centralKeep.',1,[]);
        centralVals = centralArr(centralArr ~= -1);
        centralValsLog = log(double(centralVals));
        
        f = figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(4,2,1);
        histogram(centralValsLog, 10);
        title('Num bins = 10');
        subplot(4,2,3);
        histogram(centralValsLog, 25);
        title('Num bins = 25');
        subplot(4,2,5);
        histogram(centralValsLog, 50);
        title('Num bins = 50');
        subplot(4,2,7);
        histogram(centralValsLog, 100);
        title('Num bins = 100');
        subplot(4,2,[2,4,6,8]);
        imshow(img);
        title(sprintf('Mouse ID=%s', mouseID));
        saveas(f, sprintf('./tmp/hists/%s.fig', exid));
        saveas(f, sprintf('./tmp/hists/%s.png', exid));
        close all;
        
        h = histogram(centralVals, 0:1:255);
        exprCentral = [exprCentral {h.Values}];
        close all;
        
    catch
        continue;
    end
end
end