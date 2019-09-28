% load('./dbs/analysisdb.mat');
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

OBS = 'slice';

[groupsStrio, namesStrio] = plot.group.groupmice2(micedb, 'Strio');
[groupsMatrix, namesMatrix] = plot.group.groupmice2(micedb, 'Matrix');

[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsStrio, 'UniformOutput', false);
[datMatrix, nMatrixAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group, OBS), groupsMatrix, 'UniformOutput', false);

COLORS = cbrewer('qual', 'Set2', 10);

figure;
subplot(1,2,1);
plot.cdfcont(datStrio, namesStrio, COLORS);
ylabel('CDF');
xlabel('# Spines per Dendrite Length (mm)');
subplot(1,2,2);
plot.plotbars(datStrio, namesStrio, COLORS);
ylabel('# Spines per Dendrite Length (mm) -- Slice observation');
xlabel('Groups');
subplot(1,2,2);
sgtitle([sprintf('STRIO (Observation %s)', OBS) newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio)]);

figure;
subplot(1,2,1);
plot.cdfcont(datMatrix, namesMatrix, COLORS);
ylabel('CDF');
xlabel('# Spines per Dendrite Length (mm)');
subplot(1,2,2);
plot.plotbars(datMatrix, namesMatrix, COLORS);
ylabel('Animal Avg # Spines per Dendrite Length (mm)');
xlabel('Groups');
sgtitle([sprintf('MATRIX (Observation %s)', OBS) newline ...
    mktitle(namesMatrix, nMatrixAnimals, datMatrix)]);

function [data, nAnimals] = getgroupdata(analysisdb, group, obs)
data = [];
nAnimals = 0;

for i=1:length(group)
    mouse = group{i};
    spines = msnspines.plot.getspines(analysisdb, mouse.ID, obs);
    data = [data spines];
    if ~isempty(spines); nAnimals = nAnimals + 1; end
end
end

function ttle = mktitle(names, nAnimals, dat)
n = length(names);
nSlices = cellfun(@length, dat);

% ttlSlices = ['SLICES'];
% for i=1:n
%     ttlSlices = [ttlSlices  '    ' ...
%         sprintf(['# ' names{i} ' = %d'], nSlices(i))];
% end

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

ttle = [ttlAnimals newline ttlP];
end