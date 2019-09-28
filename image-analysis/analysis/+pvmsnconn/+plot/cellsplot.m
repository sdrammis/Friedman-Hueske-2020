% load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/analysisdb.mat');
% load('./dbs/analysisdb-countstmp.mat');
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

COLORS = cbrewer('qual', 'Set2', 10);

[groupsStrio, namesStrio] = plot.group.groupmice4(micedb, 'Strio');
[groupsMatrix, namesMatrix] = plot.group.groupmice4(micedb, 'Matrix');

[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsStrio, 'UniformOutput', false);
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

figure;
subplot(1,2,1);
plot.cdfcont(datStrio, namesStrio, COLORS);
legend(namesStrio);
xlabel('# Putative Terminals');
title('CDF - Cell Level');
subplot(1,2,2);
plot.plotbars(datStrio, namesStrio, COLORS, 'nodots');
title('Bars - Cell Level');
xlabel('Groups');
ylabel('# Putative Terminals');
sgtitle(['PVMSN - STRIO - CELLS - ' newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio)]);

figure;
subplot(1,2,1);
plot.cdfcont(datMatrix, namesMatrix, COLORS);
legend(namesMatrix);
xlabel('# Putative Terminals');
title('CDF - Cell Level');
subplot(1,2,2);
plot.plotbars(datMatrix, namesMatrix, COLORS, 'nodots');
xlabel('Groups');
ylabel('# Putative Terminals');
title('Bars - Cell Level');
sgtitle(['PVMSN - MATRIX - CELLS - ' newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

function [data, nAnimals] = getgroupdata(analysisdb, group)
data = [];
nAnimals = 0;
for i=1:length(group)
    mouse = group{i};
    blobs = pvmsnconn.plot.getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end
    
    mouse.ID
    blobs = blobs(~isnan(blobs));
    
    data = [data blobs];
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

ttlKS = ['KS-TEST'];
pairs = nchoosek(1:n,2);
for i=1:size(pairs,1)
    a = pairs(i,1);
    b = pairs(i,2);
    
    aDat = dat{a};
    bDat = dat{b};
    if isempty(aDat) || isempty(bDat)
        continue;
    end
    
    ttlKS = [ttlKS  '    ' ...
        sprintf([names{a} ' v ' names{b} ' p=%.3f'], utils.kstest2p(dat{a}, dat{b}))];
    if mod(i,3) == 0; ttlKS = [ttlKS newline]; end
end

ttle = [ttlCells newline ttlAnimals newline ttlP newline ttlKS];
end
