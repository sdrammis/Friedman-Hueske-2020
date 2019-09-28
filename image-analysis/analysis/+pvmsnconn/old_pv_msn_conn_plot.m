DATA_TABLE_PATH = "/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/pv_msn/data/dataTable_v3.mat";

data = load(DATA_TABLE_PATH);
T = data.data;
T.Properties.VariableNames = {'mouseID', 'health', 'striosomality', ...
    'learned', 'file', 'numBlobs', 'cellAreaPixels' };

run_plot(T, @get_per_cell, 0.2, @plot_density_disc, @plot_cdf_disc);
% run_plot(T, @get_per_cell_area, 0.00000002, @plot_density_cont, @plot_cdf_cont);

function run_plot(T, getter, jitter, densityPlotter, cdfPlotter)
COLORS = cbrewer('qual', 'Set2', 10);

strioWTL = getter(T, 'WT', 'Strio', 1);
strioWTNL = getter(T, 'WT', 'Strio', 0);
strioHDNL = getter(T, 'HD', 'Strio', 0);

matrixWTL = getter(T, 'WT', 'Matrix', 1);
matrixWTNL = getter(T, 'WT', 'Matrix', 0);
matrixHDNL = getter(T, 'HD', 'Matrix', 0);

[~, pS1] = ttest2(strioWTL, strioWTNL);
[~, pS2] = ttest2(strioWTL, strioHDNL);
[~, pS3] = ttest2(strioWTNL, strioHDNL);

[~, pM1] = ttest2(matrixWTL, matrixWTNL);
[~, pM2] = ttest2(matrixWTL, matrixHDNL);
[~, pM3] = ttest2(matrixWTNL, matrixHDNL);

[~, pSM1] = ttest2(strioWTL, matrixWTL);
[~, pSM2] = ttest2(strioWTNL, matrixWTNL);
[~, pSM3] = ttest2(strioHDNL, matrixHDNL);

names = { 'WTL', 'WTNL', 'HDNL' };
figure;
subplot(2,1,1);
plot.plotbars({strioWTL, strioWTNL, strioHDNL}, names, COLORS, 'nodots');
gcas(1) = gca;
ylabel('Blobs on Cell');
title(['Strio' newline sprintf(' WTL WTNL p=%.3f ', pS1) ...
    sprintf('WTL HDNL p=%.3f ', pS2) sprintf(' WTNL HDNL p=%.3f', pS3) newline ...
    make_title(T, 'Strio', 'WT', 1) newline make_title(T, 'Strio', 'WT', 0) ...
    newline make_title(T, 'Strio', 'HD', 0)]);
subplot(2,1,2);
plot.plotbars({matrixWTL, matrixWTNL, matrixHDNL}, names, COLORS, 'nodots');
gcas(2) = gca;
ylabel('Blobs on Cell');
title(['Matrix' newline sprintf(' WTL WTNL p=%.3f ', pM1) newline ...
    sprintf(' WTL HDNL p=%.3f ', pM2) sprintf(' WTNL HDNL p=%.3f', pM3) newline ...
    make_title(T, 'Matrix', 'WT', 1) newline make_title(T, 'Matrix', 'WT', 0) ...
    newline make_title(T, 'Matrix', 'HD', 0)]);
allYLim = get(gcas, {'YLim'});
allYLim = cat(2, allYLim{:});
set(gcas, 'YLim', [min(allYLim), max(allYLim)]);

sgtitle(['Strio vs Matrix ' sprintf('WTL p=%.3f ', pSM1) ...
    sprintf('WTNL p=%.3f ', pSM2) sprintf('HDNL p=%.3f', pSM3)]);

% figure;
% subplot(2,2,1); 
% densityPlotter({strioWTL, strioWTNL, strioHDNL}, names);
% title('Strio PDF');
% xlabel('Number of Connection Points');
% ylabel('Number of Cells with # Dots');
% subplot(2,2,2);
% cdfPlotter({strioWTL, strioWTNL, strioHDNL}, names);
% title('Strio CDF');
% xlabel('Number of Connection Points');
% ylabel('Number of Cells with <= # Dots');
% subplot(2,2,3); 
% densityPlotter({matrixWTL, matrixWTNL, matrixHDNL}, names);
% title('Matrix PDF');
% xlabel('Number of Connection Points');
% ylabel('Number of Cells with # Dots');
% subplot(2,2,4);
% cdfPlotter({matrixWTL, matrixWTNL, matrixHDNL}, names);
% xlabel('Number of Connection Points');
% ylabel('Number of Cells with <= # Dots');
% title('Matrix CDF');

sgtitle(['Strio -- ' newline make_title(T, 'Strio', 'WT', 1) newline ...
    make_title(T, 'Strio', 'WT', 0) newline make_title(T, 'Strio', 'HD', 0) ...
    newline 'Matrix -- ' newline make_title(T, 'Matrix', 'WT', 1) newline ...
    make_title(T, 'Matrix', 'WT', 0) newline make_title(T, 'Matrix', 'HD', 0)])
end

function title_ = make_title(T, striosomality, health, learned)
subT = T(T.health == health & T.learned == learned & T.striosomality == striosomality,:);
numDots = sum(subT.numBlobs);
numCells = height(subT);
numSlices = length(unique(subT.file));
numMice = length(unique(subT.mouseID));
title_ = sprintf('%s%s - %d PV dots, %d msn cells, %d zstacks, %d animals', ...
    health, utils.tern(learned, 'L', 'NL'), numDots, numCells, numSlices, numMice);
end

function ret = get_per_cell(T, health, striosomality, didLearn)
idxs = T.health == health & T.striosomality == striosomality & T.learned == didLearn;
ret = T.numBlobs(idxs);
end

function ret = get_per_cell_area(T, health, striosomality, didLearn)
idxs = T.health == health & T.striosomality == striosomality & T.learned == didLearn;
ret = T.numBlobs(idxs) ./ T.cellAreaPixels(idxs);
end

function ret = get_per_slice(T, health, striosomality, didLearn)
ret = [];

idxs = T.health == health & T.striosomality == striosomality & T.learned == didLearn;
subT = T(idxs, :);

subFiles = arrayfun(@char, subT.file, 'UniformOutput', false);
slices = cellfun(@(s) s(1:regexp(s, '_-?[0-9]+_res.mat')-1), subFiles, 'UniformOutput', false);
slicesUnique = unique(slices);
for i=1:length(slicesUnique)
    sliceT = subT(strcmp(slices, slicesUnique(i)),:);
    ret = [ret; sum(sliceT.numBlobs) / height(sliceT)];
end
end

function ret = get_per_mouse(T, health, striosomality, didLearn)
ret = [];

idxs = T.health == health & T.striosomality == striosomality & T.learned == didLearn;
subT = T(idxs, :);
mouseIDs = unique(subT.mouseID);
for i=1:length(mouseIDs)
    mouseT = subT(subT.mouseID == mouseIDs(i),:);
    ret = [ret; sum(mouseT.numBlobs) / height(mouseT)];
end
end
