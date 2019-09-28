learnedWT = get_mice(miceType, 'health', 'WT', 'learned');
nlearnedWT = get_mice(miceType, 'health', 'WT', 'not-learned');
nlearnedHD = get_mice(miceType, 'health', 'HD', 'not-learned');

cellsLWT = get_slice_cells(learnedWT, dimensions);
cellsNLWT = get_slice_cells(nlearnedWT, dimensions);
cellsNLHD = get_slice_cells(nlearnedHD, dimensions);

names = { 'Learned WT', 'Not Learned WT', 'Not Learned HD' };
figure;
subplot(2, 2, 1);
plot_bars({ cellsLWT.medial, cellsNLWT.medial, cellsNLHD.medial }, names);
title('Num Cell Bodies / Area - Medial');
ylabel('Num Cell Bodies per MM^2');
ylim([0 140]);
subplot(2, 2, 2);
plot_bars({ cellsLWT.lateral, cellsNLWT.lateral, cellsNLHD.lateral }, names);
title('Num Cell Bodies / Area - Lateral');
ylabel('Num Cell Bodies per MM^2');
ylim([0 140]);
subplot(2, 2, 3);
plot_bars({ cellsLWT.central, cellsNLWT.central, cellsNLHD.central }, names);
title('Num Cell Bodies / Area - Central');
ylabel('Num Cell Bodies per MM^2');
ylim([0 140]);
subplot(2, 2, 4);
plot_bars({ cellsLWT.overall, cellsNLWT.overall, cellsNLHD.overall }, names);
title('Num Cell Bodies / Area - Overall');
ylabel('Num Cell Bodies per MM^2');
ylim([0 140]);

function sliceCells = get_slice_cells(mice, dimensions)
miceIDs = {mice(:).ID};
[cellsMedial, cellsLateral, cellsCentral, cellsOverall] = ...
    cellfun(@(id) get_cells(id, dimensions), miceIDs, 'UniformOutput', false);

sliceCells.medial = horzcat(cellsMedial{:});
sliceCells.central = horzcat(cellsCentral{:});
sliceCells.lateral = horzcat(cellsLateral{:});
sliceCells.overall = horzcat(cellsOverall{:});
end

function [cellsMedial, cellsLateral, cellsCentral, cellsOverall] = get_cells(mouseID, dimensions)
DATA_PATH = '/run/user/1000/gvfs/smb-share:server=chunky.mit.edu,share=smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/done';
cellsMedial = [];
cellsCentral = [];
cellsLateral = [];
cellsOverall = [];

fileObjs = dir([DATA_PATH '/' sprintf('*_%s_*-data.mat', mouseID)]);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    filename = fileObjs(i).name;
    try
        load([DATA_PATH '/' filename]);
        [medialRegion, centralRegion, lateralRegion] = split_quadrants(striatumMask);
    catch
        continue;
    end
    
    s = strfind(filename, sprintf('%s_slice', mouseID));
    substr = filename(s:s+length(mouseID)+6);
    
    dim = -1;
    for j=1:height(dimensions)
        if ~isempty(regexpi(dimensions.slice(j), substr))
           dim = dimensions.width(j) * dimensions.height(j);
           break;
        end
    end
    
    if dim == -1
        continue;
    end
    
    [n, m] = size(striatumMask);
    pixelSize = dim / (n*m);
    areaMedial = sum(sum(medialRegion)) * pixelSize;
    areaCentral = sum(sum(centralRegion)) * pixelSize;
    areaLateral = sum(sum(lateralRegion)) * pixelSize;
    areaOverall = areaMedial + areaCentral + areaLateral;
        
    cellsMedial = [cellsMedial (numCellsMedial / areaMedial)];
    cellsCentral = [cellsCentral (numCellsCentral / areaCentral)];
    cellsLateral = [cellsLateral (numCellsLateral / areaLateral)];
    cellsOverall = [cellsOverall ((numCellsMedial + numCellsLateral + numCellsCentral) / areaOverall)];
end
end
