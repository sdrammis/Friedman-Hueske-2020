% load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/analysisdb.mat');
% load('./dbs/analysisdb-countstmp.mat');
% load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

EDGES = 0:.1:1;
COLORS = cbrewer('qual', 'Set2', 10);

[groupsStrio, namesStrio] = plot.group.groupmice4(micedb, 'Strio');
[groupsMatrix, namesMatrix] = plot.group.groupmice4(micedb, ...
                                                  'Matrix');

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

striocdfs = {};
matrixcdfs = {};

figure;
subplot(2,2,[1,3]);
hold on;
for iStrio=1:length(datStrio)
    avgcdf = plot.avgcdf(gca, datStrio{iStrio}, COLORS(iStrio,:), []);
    striocdfs{end+1} = avgcdf;
end
plot.clegend(num2cell(COLORS(1:length(namesStrio),:),2), namesStrio, 'southeast');
xlabel('# Putative Terminals');
title('Avgeraged CDF');
subplot(2,2,2);
plot.plotbars(datStrioMean, namesStrio, COLORS);
ylabel('Animal Avg # Putative Terminals');
xlabel('Groups');
title('Average # Putative Terminals Per Animal');
subplot(2,2,4);
plot.avgpdf(datStrio, COLORS, EDGES);
xlabel('# Putative Terminals');
ylabel('Density');
legend(namesStrio);
title('Averaged PDF');
sgtitle(['Strio - ' mktitle(namesStrio, datStrio, datStrioMean)]);

figure;
subplot(2,2,[1,3]);
hold on;
for iMatrix=1:length(datMatrix)
    avgcdf = plot.avgcdf(gca, datMatrix{iMatrix}, COLORS(iMatrix,:), []);
    matrixcdfs{end+1} = avgcdf;
end
plot.clegend(num2cell(COLORS(1:length(namesMatrix),:),2), namesMatrix, 'southeast');
xlabel('# Putative Terminals');
title('Avgeraged CDF');
subplot(2,2,2);
plot.plotbars(datMatrixMean, namesMatrix, COLORS);
ylabel('Animal Avg # Putative Terminals');
xlabel('Groups');
title('Average # Putative Terminals Per Animal');
subplot(2,2,4);
plot.avgpdf(datMatrix, COLORS, EDGES);
xlabel('# Putative Terminals');
ylabel('Density');
legend(namesMatrix);
title('Averaged PDF');
sgtitle(['Matrix - ' mktitle(namesMatrix, datMatrix, datMatrixMean)]);

function data = getgroupdata(analysisdb, group)
data = {};
for i=1:length(group)
    mouse = group{i};
    blobs = pvmsnconn.plot.getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end
    blobs = blobs(~isnan(blobs));
    data{end+1} = blobs;
end
end

function ttle = mktitle(names, dat, datMean)
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

ttlT = ['T-TEST'];
pairs = nchoosek(1:n,2);
for i=1:size(pairs,1)
    a = pairs(i,1);
    b = pairs(i,2);

    aDat = datMean{a};
    bDat = datMean{b};
    if isempty(aDat) || isempty(bDat)
        continue;
    end

    p = utils.ttest2p(aDat, bDat);
    ttlT = [ttlT  '    '  sprintf([names{a} ' v ' names{b} ' p=%.3f'], p)];
    if mod(i,3) == 0; ttlT = [ttlT newline]; end
end
ttle = [ttlCells newline ttlAnimals newline ttlT newline];
end

function pValue = kstest2cdf(cdf1, cdf2, n1, n2)
maxlen = max(length(cdf1), length(cdf2));
cdf1(end+1:maxlen) = 1;
cdf2(end+1:maxlen) = 1;
deltaCDF  =  abs(cdf1 - cdf2);
KSstatistic   =  max(deltaCDF);
n      =  n1 * n2 /(n1 + n2);
lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);
j       =  (1:101)';
pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
pValue  =  min(max(pValue, 0), 1);
end
