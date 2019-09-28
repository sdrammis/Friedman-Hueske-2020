% load('./dbs/analysisdb.mat');
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

[groupsStrio, namesStrio] = plot.group.groupmice(micedb, 'Strio');
[groupsMatrix, namesMatrix] = plot.group.groupmice(micedb, 'Matrix');

datStrio = cellfun(@(group) getgroupdata(analysisdb, group), groupsStrio, 'UniformOutput', false);
datMatrix = cellfun(@(group) getgroupdata(analysisdb, group), groupsMatrix, 'UniformOutput', false);

datStrioMean = cellfun(@(animal) cellfun(@nanmean, animal), datStrio, 'UniformOutput', false);
datMatrixMean = cellfun(@(animal) cellfun(@nanmean, animal), datMatrix, 'UniformOutput', false);

datStrio = {{datStrio{1}{:} datStrio{2}{:}} datStrio{3}};
datStrioMean = {[datStrioMean{1} datStrioMean{2}] datStrioMean{3}};
namesStrio = {'WT', 'HD'};
datMatrix = {{datMatrix{1}{:} datMatrix{2}{:}} datMatrix{3}};
datMatrixMean = {[datMatrixMean{1} datMatrixMean{2}] datMatrixMean{3}};
namesMatrix = {'WT', 'HD'};

COLORS = cbrewer('qual', 'Set2', 10);

figure;
subplot(1,2,1);
plot.plotbars(datStrioMean, namesStrio, COLORS);
ylabel('Animal Avg # Spines per Dendrite Length (mm)');
xlabel('Groups');
title(['Strio - ' mktitle(datStrio, datStrioMean)]);
subplot(1,2,2);
plot.plotbars(datMatrixMean, namesMatrix, COLORS);
ylabel('Animal Avg # Spines per Dendrite Length (mm)');
xlabel('Groups');
title(['Matrix - ' mktitle(datMatrix, datMatrixMean)]);
sgtitle('Animal Avg # Spines per Dendrite Length (mm)');

function data = getgroupdata(analysisdb, group)
data = [];
for i=1:length(group)
    mouse = group{i};
    spines = msnspines.plot.getspines(analysisdb, mouse.ID);
    data = [data {spines}];
end


function ttle = mktitle(dat, datMean)
numSamples = cellfun(@(group) sum(cellfun(@(x) sum(~isnan(x)), group)), dat, 'UniformOutput', false);
numAnimals = cellfun(@(group) nnz(cellfun(@(x) sum(~isnan(x)), group)), dat, 'UniformOutput', false);

ttle = [ ...
    sprintf('# WT Samples = %d', numSamples{1}) '    ' ...
    sprintf('# HD Samples = %d', numSamples{2}) '    ' ...
    sprintf('# WT Animals = %d',  numAnimals{1}) '    ' ...
    sprintf('# HD Animals = %d', numAnimals{2}) '    ' ...
   newline ...
    'T-Test: ' ...
    sprintf('WT v HD p = %.3f', utils.ttest2p(datMean{1}, datMean{2})) ...
    ];
end