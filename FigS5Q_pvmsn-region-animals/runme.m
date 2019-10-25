% Load files: analysisdb_pvmsn_regions.mat and micedb.mat

EDGES = 0:.1:1;
COLORS = cbrewer('qual', 'Set2', 10);

[groupsStrio, namesStrio] = groupmice4(micedb, 'Strio');
[groupsMatrix, namesMatrix] = groupmice4(micedb, 'Matrix');

datStrio = cellfun(@(group) getgroupdata(analysisdb, group), groupsStrio, 'UniformOutput', false);
datMatrix = cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

datStrioMean = cellfun(@(animal) cellfun(@nanmean, animal), datStrio, 'UniformOutput', false);
datMatrixMean = cellfun(@(animal) cellfun(@nanmean, animal), datMatrix, 'UniformOutput', false);

strioIdxs = ~cellfun(@isempty, datStrio);
atStrio = datStrio(strioIdxs);
namesStrio = namesStrio(strioIdxs);
datStrioMean = datStrioMean(strioIdxs);

matrixIdxs = ~cellfun(@isempty, datMatrix);
datMatrix = datMatrix(matrixIdxs);
namesMatrix = namesMatrix(matrixIdxs);
datMatrixMean = datMatrixMean(matrixIdxs);

figure;
subplot(1,2,1);
plotbars(datStrioMean, namesStrio, COLORS);
ylabel('Animal Avg # Putative Terminals');
xlabel('Groups');
title('Strio');
subplot(1,2,2);
plotbars(datMatrixMean, namesMatrix, COLORS);
ylabel('Animal Avg # Putative Terminals');
xlabel('Groups');
title('Matrix');

function data = getgroupdata(analysisdb, group)
data = {};
for i=1:length(group)
    mouse = group{i};
    blobs = getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end

    blobs = blobs(~isnan(blobs));
    data{end+1} = blobs;
end
end
