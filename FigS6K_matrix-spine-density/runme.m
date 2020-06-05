% Load files: analysisdb-spinesV2-2.mat, micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);
OBS = 'slice';

[groupsMatrix, namesMatrix] = groupmice2(micedb, 'Matrix');
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsMatrix, 'UniformOutput', false);

figure;
plotbars(datMatrix, namesMatrix, COLORS);
ylabel('Animal Avg # Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('MATRIX (Observation %s)', OBS) newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

x = datMatrix{1};
y = datMatrix{2};
[~,ttestp] = ttest2(x,y);
signrankp = ranksum(x,y);
fprintf('ttest p = %d \n', ttestp);
fprintf('signrank p = %d \n', signrankp);

function [data, nAnimals] = getgroupdata(analysisdb, group, obs)
data = [];
nAnimals = 0;

for i=1:length(group)
    mouse = group{i};
    spines = getspines(analysisdb, mouse.ID, obs);
    data = [data spines];
    if ~isempty(spines); nAnimals = nAnimals + 1; end
end
end

function ttle = mktitle(names, nAnimals, dat)
n = length(names);
nSlices = cellfun(@length, dat);

ttlSlices = ['SLICES'];
for i=1:n
    ttlSlices = [ttlSlices  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nSlices(i))];
end

ttlAnimals = ['ANIMALS'];
for i=1:n
    ttlAnimals = [ttlAnimals  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nAnimals{i})];
end

ttle = [ttlAnimals newline ttlSlices];
end