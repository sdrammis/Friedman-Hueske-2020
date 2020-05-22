% Load files: analysisdb-spinesV2-2.mat, micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);
OBS = 'slice';

[groupsMatrixMash, namesMatrixMash] = groupmice2(micedb, 'Matrix', 'Mash');
[datMatrixMash, nMatrixAnimalsMash] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsMatrixMash, 'UniformOutput', false);
[groupsMatrixDlx, namesMatrixDlx] = groupmice2(micedb, 'Matrix', 'Dlx');
[datMatrixDlx, nMatrixAnimalsDlx] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsMatrixDlx, 'UniformOutput', false);

figure;
subplot(1,2,1);
plotbars(datMatrixMash, namesMatrixMash, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('Matrix Mash (Observation %s)', OBS) newline ...
    mktitle(namesMatrixMash, nMatrixAnimalsMash, datMatrixMash)]);
subplot(1,2,2);
plotbars(datMatrixDlx, namesMatrixDlx, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('Matrix Dlx (Observation %s)', OBS) newline ...
    mktitle(namesMatrixDlx, nMatrixAnimalsDlx, datMatrixDlx)]);

% x = datStrioMash{1};
% y = datStrioMash{2};
% [~,ttestp] = ttest2(x,y);
% signrankp = ranksum(x,y);
% fprintf('ttest p = %d \n', ttestp);
% fprintf('signrank p = %d \n', signrankp);

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