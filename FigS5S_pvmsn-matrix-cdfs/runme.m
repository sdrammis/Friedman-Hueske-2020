% Load files: analysisdb_pvmsn.mat, micedb.mat
EDGES = 0:.1:1;
COLORS = cbrewer('qual', 'Set2', 10);

[groupsMatrix, namesMatrix] =  groupmice4(micedb, 'Matrix');
datMatrix = cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

matrixIdxs = ~cellfun(@isempty, datMatrix);
datMatrix = datMatrix(matrixIdxs);
namesMatrix = namesMatrix(matrixIdxs);

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

SAMPLE_N = 10000;
sampWTLY = groupsample(datStrio{1}, SAMPLE_N);
sampWTLO = groupsample(datStrio{2}, SAMPLE_N);
sampWTNL = groupsample(datStrio{3}, SAMPLE_N);
sampHDNL = groupsample(datStrio{4}, SAMPLE_N);

[~, p1] = kstest2(sampWTLO, sampWTLY);
[~, p2] = kstest2(sampWTLO, sampWTNL);
[~, p3] = kstest2(sampWTLO, sampHDNL);
fprintf('WTLO v WTLY, WTNL, HDNL, p = %.5f, p = %.5f, p = %.5f \n', p1, p2, p3);

function ret = groupsample(group, n)
ret = [];
for i=1:length(group)
   ret = [ret randsample(group{i}, n)];
end
end

function ret = randsample(x, n)
idxs = randi(length(x), 1, n);
ret = x(idxs); 
end

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

