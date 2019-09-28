DATA_PATH = '/annex4/afried/resultfiles/analysis_output/pv_msn_conn/data_v3';
OUT_FOLDER = '/annex4/afried/resultfiles/analysis_output/pv_msn_conn/results_v3';
outPath = [OUT_FOLDER '/pvmsn_conn_data_' datestr(now,'mmddyy_HH-MM') '.csv'];

addpath(genpath('./lib'));

M = pvmsnconn.buildregionsmap(); % Maps slice region numbers to mouse IDs
ROIs = pvmsnconn.loadROIs('./dbs/pvmsn-regions.xlsx');

outFileID = fopen(outPath, 'a');

d = dir(DATA_PATH);
isub = [d(:).isdir];
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for i=1:length(nameFolds)
    folderName = nameFolds{i};
    subDir = dir([DATA_PATH '/' folderName]);
    fileNames = {subDir.name}';
    fileNames(ismember(fileNames,{'.','..'})) = [];
    
    for j=1:length(fileNames)
        fileName = fileNames{j};
        if any(strcmp(fileName(1), {'.', '@'}))
            continue;
        end
        
        fprintf('Running %s ... \n', fileName);
        
        % Find the mouse ID for the slice file.
        [mouseID, slice, stack] = find_mouseID(M, fileName, folderName);
        if isnan(str2double(mouseID))
            fprintf('Could not extract mouseID from file %s \n', fileName);
        end
        
        % Label blobs with associated cell label.
        data = load([DATA_PATH '/' folderName '/' fileName]);
        if ~isfield(data, 'cellsMSN')
            fprintf('No cell data found for %s. \n', fileName);
            continue;
        end
        cellsMSN = data.cellsMSN;
        if sum(cellsMSN(:)) == 0 % No cells were detected.
            fprintf('No cells in cell data for  %s. \n', fileName);
            continue;
        end
        blobLabels = assign_blobs_to_cell(cellsMSN, data.blobsPV);
        
        % Write cell data to CSV file.
        cellProps = regionprops(cellsMSN, 'all');
        for k=1:length(cellProps)
            cellLabel = max(cellsMSN(cellProps(k).PixelIdxList));
            x = cellLabel.Centroid(1);
            y = cellLabel.Centroid(2);
            
            ROI = ROIs(strcmp({ROIs.Name}, fileName),:);
            if ~(x > ROI.X1 && x < ROI.X2 && y > ROI.Y1 && y < ROI.Y2)
                continue;
            end
            
            numBlobs = sum(blobLabels == cellLabel);
            cellArea = cellProps(k).Area;
            fprintf('Writing output... \n');
            fprintf(outFileID, '%s, %s, %d, %d \n', ...
                mouseID, slice, numBlobs, cellArea); % NOTE maybe incorporate pixel size.
        end
    end
end
fclose(fileID);

function [mouseID, slice, stack] = find_mouseID(M, fileName, folderName)
fileName = lower(fileName);
matchRegion = regexp(fileName, 'region [0-9]+', 'match');
if isempty(matchRegion)
    matchMouse = regexp(fileName, '-[0-9]+_slice', 'match');
    splits = split(matchMouse{1}, '_');
    mouseID = splits{1}(2:end);
    slice = regexprep(fileName, '_-?[0-9]+_res.mat', '');
else
    if strcmp(folderName, 'slides1_2')
        exp = 'exp7';
    elseif strcmp(folderName, 'slides3_4')
        exp = 'exp9';
    end
    splits = split(matchRegion{1}, ' ');
    region = splits{2};
    dat = M([exp '#' region]);
    mouseID = dat{1};
    sliceNum = dat{2};
    slice = regexprep(fileName(1:end-8), 'region [0-9]+_-?[0-9]+', [mouseID '_' sliceNum]);
end
splits2 = split(fileName(1:end-8), '_');
stack = splits2{end};
end

function blobCells = assign_blobs_to_cell(cellsMSN, blobsPV)
se = strel('disk',9,0);
cellsExpanded = imdilate(cellsMSN, se);
blobProps = regionprops(blobsPV, 'all');
blobCells = nan(length(blobProps),1);
for i=1:length(blobProps)
    centroid = blobProps(i).Centroid;
    x = round(centroid(1));
    y = round(centroid(2));
    if isnan(x) || isnan(y)
        continue;
    end
    blobCells(i) = cellsExpanded(y,x);
end
end
