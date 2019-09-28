for t=1:10
    learnedWT = get_mice(miceType, 'health', 'WT', 'learned');
    nlearnedWT = get_mice(miceType, 'health', 'WT', 'not-learned');
    nlearnedHD = get_mice(miceType, 'health', 'HD', 'not-learned');
    
    dendLWT = get_slice_dendrites(learnedWT, t);
    dendNLWT = get_slice_dendrites(nlearnedWT, t);
    dendNLHD = get_slice_dendrites(nlearnedHD, t);
    
    names = { 'Learned WT', 'Not Learned WT', 'Not Learned HD' };
    figure;
    subplot(2, 2, 1);
    plot_bars({ dendLWT.medial, dendNLWT.medial, dendNLHD.medial }, names);
    title('Dendrite Percentage Medial');
    ylim([0 0.5]);
    subplot(2, 2, 2);
    plot_bars({ dendLWT.lateral, dendNLWT.lateral, dendNLHD.lateral }, names);
    title('Dendrite Percentage Lateral');
    ylim([0 0.5]);
    subplot(2, 2, 3);
    plot_bars({ dendLWT.central, dendNLWT.central, dendNLHD.central }, names);
    title('Dendrite Percentage Central');
    ylim([0 0.5]);
    subplot(2, 2, 4);
    plot_bars({ dendLWT.overal, dendNLWT.overal, dendNLHD.overal }, names);
    title('Dendrite Percentage Overal');
    ylim([0 0.5]);
    save(f, sprintf('./tmp/threshold-%d.fig', t));
end


function sliceDend = get_slice_dendrites(mice, thresh)
miceIDs = {mice(:).ID};
[dendMedial, dendLateral, dendCentral, dendOverall] = ...
    cellfun(@(x) get_dendrites(x, thresh), miceIDs, 'UniformOutput', false);

sliceDend.medial = horzcat(dendMedial{:});
sliceDend.lateral = horzcat(dendLateral{:});
sliceDend.central = horzcat(dendCentral{:});
sliceDend.overal = horzcat(dendOverall{:});
end

function [dendMedial, dendLateral, dendCentral, dendOverall] = get_dendrites(mouseID, thresh)
% DENDRITES_PATH = '/run/user/1000/gvfs/smb-share:server=chunky.mit.edu,share=smbshare/analysis3/strio_matrix_cv/system-tree/pv_dendrite_detection/done';
% CELLS_PATH = '/run/user/1000/gvfs/smb-share:server=chunky.mit.edu,share=smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/done';
DENDRITES_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/system-tree/pv_dendrite_detection/manual';
CELLS_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/system-tree/pv_cell_body_detection/manual';

dendMedial = [];
dendLateral = [];
dendCentral = [];
dendOverall = [];

fileObjs = dir([DENDRITES_PATH '/' sprintf('*_%s_*-%d-data.mat', mouseID, thresh)]);
numFileObjs = length(fileObjs);
if numFileObjs == 0
    return;
end

for i=1:numFileObjs
    fileName = fileObjs(i).name;
    if ~contains(fileName, {'exp7', 'exp8', 'exp9'})
        continue;
    end
    
    % exclude following because of artifacts
    if contains(fileName, {'2703_slice2', '2712_slice1', '2778_slice1'})
        continue;
    end
    
    try
        dendrites = load([DENDRITES_PATH '/' fileName]);
        dendrites = dendrites.dendrites;
        cells = load([CELLS_PATH '/' fileName]);
        dendrites(logical(cells.cells)) = 0;
        [medialRegion, centralRegion, lateralRegion, point1, point2] = ...
            split_quadrants(cells.striatumMask);
    catch
        continue;
    end
    
    % create mask that does not include black holes (fiber passages)
    toKeep = logical(imgaussfilt(double(dendrites),15));
    toKeepMedial = toKeep(:,1:point1);
    toKeepCentral = toKeep(:,point1+1:point2);
    toKeepLateral = toKeep(:,point2+1:end);
    
    medialRegionKeep = medialRegion .* toKeepMedial;
    centralRegionKeep = centralRegion .* toKeepCentral;
    lateralRegionKeep = lateralRegion .* toKeepLateral;
    striatumMaskKeep = cells.striatumMask .* toKeep;
    
    areaMedial = sum(sum(medialRegionKeep));
    areaCentral = sum(sum(centralRegionKeep));
    areaLateral = sum(sum(lateralRegionKeep));
    areaOverall = areaMedial + areaCentral + areaLateral;
    
    dendritesMedial = dendrites(:,1:point1);
    dendritesMedial(~medialRegionKeep) = 0;
    dendritesCentral = dendrites(:,point1+1:point2);
    dendritesCentral(~centralRegionKeep) = 0;
    dendritesLateral = dendrites(:,point2+1:end);
    dendritesLateral(~lateralRegionKeep) = 0;
    dendritesOverall = dendrites;
    dendritesOverall(~striatumMaskKeep) = 0;
    
    areaDendMedial = sum(sum(dendritesMedial));
    areaDendCentral = sum(sum(dendritesCentral));
    areaDendLateral = sum(sum(dendritesLateral));
    areaDendOverall = sum(sum(dendritesOverall));

    dendMedial = [dendMedial (areaDendMedial / areaMedial)];
    dendCentral = [dendCentral (areaDendCentral / areaCentral)];
    dendLateral = [dendLateral (areaDendLateral / areaLateral)];
    dendOverall = [dendOverall (areaDendOverall / areaOverall)];
end
end
