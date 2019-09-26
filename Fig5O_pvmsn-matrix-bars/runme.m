% Load files: analysisdb_pvmsn.mat, micedb.mat
COLORS = cbrewer('qual', 'Set2', 10);

[groupsMatrix, namesMatrix] = groupmice4(micedb, 'Matrix');
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

figure;
plotbars(datMatrix, namesMatrix, COLORS, 'nodots');
title('Bars - Cell Level');
xlabel('Groups');
ylabel('# Putative Terminals');
title(['PVMSN - MATRIX - CELLS - ' newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

n = length(namesMatrix);
pairs = nchoosek(1:n,2);
for i=1:size(pairs,1)
    a = pairs(i,1);
    b = pairs(i,2);
    
    x = datMatrix{a};
    y = datMatrix{b};
    if isempty(x) || isempty(y)
        continue;
    end
    
    [~,ttestp] = ttest2(x,y);
    signrankp = ranksum(x,y);
    fprintf(['ttest: ' namesMatrix{a} ' v ' namesMatrix{b} ' p=%.3f \n'], ttestp);
    fprintf(['signrank: ' namesMatrix{a} ' v ' namesMatrix{b} ' p=%.3f \n'], signrankp);
end

function [data, nAnimals] = getgroupdata(analysisdb, group)
data = [];
nAnimals = 0;
for i=1:length(group)
    mouse = group{i};
    blobs = getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end
    
    data = [data blobs(~isnan(blobs))];
    nAnimals = nAnimals + 1;
end
end

function ttle = mktitle(names, nAnimals, dat)
n = length(names);
nCells = cellfun(@length, dat);

ttlCells = ['CELLS'];
for i=1:n
    ttlCells = [ttlCells  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nCells(i))];
end

ttlAnimals = ['ANIMALS'];
for i=1:n
    ttlAnimals = [ttlAnimals  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nAnimals{i})];
end
ttle = [ttlCells newline ttlAnimals];
end
