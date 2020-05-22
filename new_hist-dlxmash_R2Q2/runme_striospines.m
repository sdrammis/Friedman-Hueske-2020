% Load files: analysisdb-spinesV2-2.mat, micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);
OBS = 'slice';

[groupsStrioMash, namesStrioMash] = groupmice2(micedb, 'Strio', 'Mash');
[datStrioMash, nStrioAnimalsMash] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsStrioMash, 'UniformOutput', false);
[groupsStrioDlx, namesStrioDlx] = groupmice2(micedb, 'Strio', 'Dlx');
[datStrioDlx, nStrioAnimalsDlx] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsStrioDlx, 'UniformOutput', false);

figure;
subplot(1,2,1);
plotbars(datStrioMash, namesStrioMash, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('STRIO Mash (Observation %s)', OBS) newline ...
    mktitle(namesStrioMash, nStrioAnimalsMash, datStrioMash)]);
subplot(1,2,2);
plotbars(datStrioDlx, namesStrioDlx, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('STRIO Dlx (Observation %s)', OBS) newline ...
    mktitle(namesStrioDlx, nStrioAnimalsDlx, datStrioDlx)]);

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