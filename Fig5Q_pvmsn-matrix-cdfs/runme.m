% Load files: analysisdb_pvmsn.mat, micedb.mat
EDGES = 0:.1:1;
COLORS = cbrewer('qual', 'Set2', 10);

[groupsMatrix, namesMatrix] =  groupmice4(micedb, 'Matrix');
datMatrix = cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);
datMatrixMean = cellfun(@(animal) cellfun(@nanmean, animal), datMatrix, 'UniformOutput', false);

matrixIdxs = ~cellfun(@isempty, datMatrix);
datMatrix = datMatrix(matrixIdxs);
namesMatrix = namesMatrix(matrixIdxs);
datMatrixMean = datMatrixMean(matrixIdxs);

figure;
hold on;
matrixcdfs = {};
for iMatrix=1:length(datMatrix)
    matrixcdfs{end+1} = avgcdf(gca, datMatrix{iMatrix}, COLORS(iMatrix,:), []);
end
clegend(num2cell(COLORS(1:length(namesMatrix),:),2), namesMatrix, 'southeast');
xlabel('# Putative Terminals');
title('Avgeraged CDF');
title(['Matrix - ' mktitle(namesMatrix, datMatrix)]);

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

function ttle = mktitle(names, dat)
n = length(names);
nAnimals = cellfun(@(group) sum(cellfun(@(animal) ~isempty(animal), group)), dat);
nCells = cellfun(@(group) sum(cellfun(@length, group)), dat);

ttlCells = ['CELLS'];
for i=1:n
    ttlCells = [ttlCells  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nCells(i))];
end

ttlAnimals = ['ANIMALS'];
for i=1:n
    ttlAnimals = [ttlAnimals  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nAnimals(i))];
end

ttle = [ttlCells newline ttlAnimals];
end

