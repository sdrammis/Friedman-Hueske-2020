% Load files: analysisdb-spinesV2-2.mat, micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);
OBS = 'slice';

[groupsStrio, namesStrio] = groupmice3(micedb, 'Strio');
[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsStrio, 'UniformOutput', false);

figure;
plotbars(datStrio, namesStrio, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('STRIO (Observation %s)', OBS) newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio)]);

dat1 = datStrio{1};
dat2 = datStrio{2};
dat3 = datStrio{3};

[~,ttestp1] = ttest2(dat1,dat2);
[~,ttestp2] = ttest2(dat1,dat3);
[~,ttestp3] = ttest2(dat2,dat3);
fprintf('ttest p (WTL v WTNL) = %d \n', ttestp1);
fprintf('ttest p (WTL v HD) = %d \n', ttestp2);
fprintf('ttest p (WTNL v HD) = %d \n', ttestp3);

signrankp1 = ranksum(dat1,dat2);
signrankp2 = ranksum(dat1,dat3);
signrankp3 = ranksum(dat2,dat3);
fprintf('signrank p (WTL v WTNL) = %d \n', signrankp1);
fprintf('signrank p (WTL v HD) = %d \n', signrankp2);
fprintf('signrank p (WTNL v HD) = %d \n', signrankp3);

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