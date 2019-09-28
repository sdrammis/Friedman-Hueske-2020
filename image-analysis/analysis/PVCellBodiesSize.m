learnedWT = get_mice(miceType, 'health', 'WT', 'learned');
nlearnedWT = get_mice(miceType, 'health', 'WT', 'not-learned');
nlearnedHD = get_mice(miceType, 'health', 'HD', 'not-learned');

sizesLWT = get_slice_cell_sizes(learnedWT, dimensions);
sizesNLWT = get_slice_cell_sizes(nlearnedWT, dimensions);
sizesNLHD = get_slice_cell_sizes(nlearnedHD, dimensions);

names = { 'Learned WT', 'Not Learned WT', 'Not Learned HD' };
figure;
subplot(2, 2, 1);
plot_bars({ sizesLWT.medial, sizesNLWT.medial, sizesNLHD.medial }, names);
title('Cell Body Avg Size - Medial');
ylabel('Avg Cell Body Size in MM^2');
subplot(2, 2, 2);
plot_bars({ sizesLWT.lateral, sizesNLWT.lateral, sizesNLHD.lateral }, names);
title('Cell Body Avg Size - Lateral');
ylabel('Avg Cell Body Size in MM^2');
subplot(2, 2, 3);
plot_bars({ sizesLWT.central, sizesNLWT.central, sizesNLHD.central }, names);
title('Cell Body Avg Size - Central');
ylabel('Avg Cell Body Size in MM^2');
subplot(2, 2, 4);
plot_bars({ sizesLWT.overall, sizesNLWT.overall, sizesNLHD.overall }, names);
title('Cell Body Avg Size - Overall');
ylabel('Avg Cell Body Size in MM^2');

function sliceSizes = get_slice_cell_sizes(mice, dimensions)
miceIDs = {mice(:).ID};
[sizesMedial, sizesLateral, sizesCentral, sizesOverall] = ...
    cellfun(@(id) get_sizes(id, dimensions), miceIDs, 'UniformOutput', false);

sliceSizes.medial = horzcat(sizesMedial{:});
sliceSizes.central = horzcat(sizesCentral{:});
sliceSizes.lateral = horzcat(sizesLateral{:});
sliceSizes.overall = horzcat(sizesOverall{:});
end

function [sizesMedial, sizesLateral, sizesCentral, sizesOverall] = get_sizes(mouseID, dimensions)
DATA_PATH = '/run/user/1000/gvfs/smb-share:server=chunky.mit.edu,share=smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/done';
sizesMedial = [];
sizesCentral = [];
sizesLateral = [];
sizesOverall = [];

fileObjs = dir([DATA_PATH '/' sprintf('*_%s_*-data.mat', mouseID)]);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    filename = fileObjs(i).name;
    try
        load([DATA_PATH '/' filename]);
        [n, m] = size(striatumMask);
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
    
    pixelSize = dim / (n*m);
    sizesMedial = [sizesMedial ((areaCellsMedial / numCellsMedial) * pixelSize)];
    sizesCentral = [sizesCentral ((areaCellsCentral / numCellsCentral) * pixelSize)];
    sizesLateral = [sizesLateral ((areaCellsLateral / numCellsLateral) * pixelSize)];
    sizesOverall = [sizesOverall ((areaCellsMedial + areaCellsCentral + areaCellsLateral) / (numCellsMedial + numCellsCentral + numCellsLateral) * pixelSize)];
end
end
