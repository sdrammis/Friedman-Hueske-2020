% Load files: analysisdb_pvmsn_regions.mat and micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);

[groupsStrio, namesStrio] = groupmice4(micedb, 'Strio');
[groupsMatrix, namesMatrix] = groupmice4(micedb, 'Matrix');

[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsStrio, 'UniformOutput', false);
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

figure;
subplot(1,2,1);
plotbars(datStrio, namesStrio, COLORS, 'nodots');
xlabel('Groups');
ylabel('# Putative Terminals');
sgtitle(['PVMSN - STRIO - CELLS - ' newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio)]);
subplot(1,2,2);
plotbars(datMatrix, namesMatrix, COLORS, 'nodots');
xlabel('Groups');
ylabel('# Putative Terminals');
sgtitle(['PVMSN - MATRIX - CELLS - ' newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

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
