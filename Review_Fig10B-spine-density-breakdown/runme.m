% Load files: analysisdb.mat, micedb.mat

COLORS = cbrewer('qual', 'Set2', 10);
OBS = 'slice';

[groupsStrio, namesStrio] = groupmice3(micedb, 'Strio');
[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsStrio, 'UniformOutput', false);
[groupsMatrix, namesMatrix] = groupmice3(micedb, 'Matrix');
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsMatrix, 'UniformOutput', false);

names = {...
    'CTL strio', 'CTNL strio', 'HD strio', ...
    'CTL matrix', 'CTNL matrix', 'HD matrix'};
figure;
plotbars([datStrio datMatrix], names, COLORS);
ylabel('# Spines per Dendrite Length (mm)');
xlabel('Groups');
title([sprintf('STRIO (Observation %s)', OBS) newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio) newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

datStrio1 = datStrio{1};
datStrio2 = datStrio{2};
datStrio3 = datStrio{3};
fprintf('======= strio stats ======== \n');
[~,ttestp1] = ttest2(datStrio1,datStrio2);
[~,ttestp2] = ttest2(datStrio1,datStrio3);
[~,ttestp3] = ttest2(datStrio2,datStrio3);
fprintf('ttest p (WTL v WTNL) = %d \n', ttestp1);
fprintf('ttest p (WTL v HD) = %d \n', ttestp2);
fprintf('ttest p (WTNL v HD) = %d \n', ttestp3);
signrankp1 = ranksum(datStrio1,datStrio2);
signrankp2 = ranksum(datStrio1,datStrio3);
signrankp3 = ranksum(datStrio2,datStrio3);
fprintf('signrank p (WTL v WTNL) = %d \n', signrankp1);
fprintf('signrank p (WTL v HD) = %d \n', signrankp2);
fprintf('signrank p (WTNL v HD) = %d \n', signrankp3);

datMatrix1 = datMatrix{1};
datMatrix2 = datMatrix{2};
datMatrix3 = datMatrix{3};
fprintf('======= matrix stats ======== \n');
[~,ttestp1] = ttest2(datMatrix1,datMatrix2);
[~,ttestp2] = ttest2(datMatrix1,datMatrix3);
[~,ttestp3] = ttest2(datMatrix2,datMatrix3);
fprintf('ttest p (WTL v WTNL) = %d \n', ttestp1);
fprintf('ttest p (WTL v HD) = %d \n', ttestp2);
fprintf('ttest p (WTNL v HD) = %d \n', ttestp3);
signrankp1 = ranksum(datMatrix1,datMatrix2);
signrankp2 = ranksum(datMatrix1,datMatrix3);
signrankp3 = ranksum(datMatrix2,datMatrix3);
fprintf('signrank p (WTL v WTNL) = %d \n', signrankp1);
fprintf('signrank p (WTL v HD) = %d \n', signrankp2);
fprintf('signrank p (WTNL v HD) = %d \n', signrankp3);


function [data, nAnimals] = getgroupdata(analysisdb, group, obs)
data = [];
nAnimals = 0;

mice = {};

for i=1:length(group)
    mouse = group{i};
    spines = getspines(analysisdb, mouse.ID, obs);
    data = [data spines];
    if ~isempty(spines); nAnimals = nAnimals + 1; mice{end+1} = mouse; end
end

ages = cellfun(@getperfage, mice);
fprintf('ages mean = %.3f, stderr = %.3f \n', nanmean(ages), std_error(ages));
fprintf('ages min = %.3f, max = %.3f \n', min(ages), max(ages));
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