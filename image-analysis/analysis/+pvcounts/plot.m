% load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/analysisdb.mat');
load('./dbs/analysisdb-countstmp.mat');
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

COLORS = cbrewer('qual', 'Set2', 10);
REGION_NAMES = {'TL', 'TM', 'TR', 'BL', 'BM', 'BR'};
YLIM = [0 25];

[groups, names] = plot.group.groupmice4(micedb, 'all');
[dat, nAnimals]  = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groups, 'UniformOutput', false);

datAll = cellfun(@(x) x(:,1), dat, 'UniformOutput', false);
datRegions = cellfun(@getregiondata, dat, 'UniformOutput', false);

figure;
subplot(2,3,[1,4]);
plot.plotbars(datAll, names, COLORS, 'nodots');
ylabel('Cell Count -- Stack');
title(['All Regions' newline mktitle(names, datAll)]);
subplot(2,3,2);
plot.plotbars(datRegions{1}, REGION_NAMES, COLORS, 'nodots');
ylabel('Cell Count -- Stack');
title(['WTL Young' newline mktitle(REGION_NAMES, datRegions{1})]);
ylim(YLIM);
subplot(2,3,3);
plot.plotbars(datRegions{2}, REGION_NAMES, COLORS, 'nodots');
ylabel('Cell Count -- Stack');
title(['WTL Old' newline mktitle(REGION_NAMES, datRegions{2})]);
ylim(YLIM);
subplot(2,3,5);
plot.plotbars(datRegions{3}, REGION_NAMES, COLORS, 'nodots');
ylabel('Cell Count -- Stack');
title(['WTNL' newline mktitle(REGION_NAMES, datRegions{3})]);
ylim(YLIM);
subplot(2,3,6);
plot.plotbars(datRegions{4}, REGION_NAMES, COLORS, 'nodots');
ylabel('Cell Count -- Stack');
title(['HDNL' newline mktitle(REGION_NAMES, datRegions{4})]);
ylim(YLIM);
sgtitle(['PV CELLS' newline mksuptitle(names, nAnimals, datAll)]);

function [data, nAnimals] = getgroupdata(analysisdb, group)
data = [];
nAnimals = 0;
for i=1:length(group)
    mouse = group{i};
    idxs = strcmp({analysisdb.mouseID}, mouse.ID) & ~strcmp({analysisdb.stack}, 'P');
    counts = {analysisdb(idxs).pvcounts};
    idxs = ~cellfun(@isempty, counts);
    if all(~idxs)
        continue;
    end
%     cellsarr = cellfun(@(c) (c{:,1:7}), counts(idxs), 'UniformOutput', false);
    cellsarr = cellfun(@(c) (c{:,1:7}./c{:,8:end}), counts(idxs), 'UniformOutput', false);
    data = [data; cell2mat(cellsarr')];
    nAnimals = nAnimals + 1;
end
end

function data = getregiondata(groupdata)
dat = groupdata(:,2:end);
data = mat2cell(dat, [size(dat,1)], ones(1, size(dat, 2)));
end

function ttle = mksuptitle(names, nAnimals, dat)
n = length(names);
nSlices = cellfun(@length, dat);

ttlCells = ['SLICES'];
for i=1:n
    ttlCells = [ttlCells  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nSlices(i))];
end

ttlAnimals = ['ANIMALS'];
for i=1:n
    ttlAnimals = [ttlAnimals  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nAnimals{i})];
end
ttle = [ttlCells newline ttlAnimals];
end

function ttle = mktitle(names, dat)
n = length(names);

ttlP = ['T-TEST'];
pairs = nchoosek(1:n,2);
for i=1:size(pairs,1)
    a = pairs(i,1);
    b = pairs(i,2);
    
    aDat = dat{a};
    bDat = dat{b};
    if isempty(aDat) || isempty(bDat)
        continue;
    end
    
    ttlP = [ttlP  '    ' ...
        sprintf([names{a} ' v ' names{b} ' p=%.3f'], utils.ttest2p(dat{a}, dat{b}))];
    if mod(i,3) == 0; ttlP = [ttlP newline]; end
end

ttle = [ttlP];
end
