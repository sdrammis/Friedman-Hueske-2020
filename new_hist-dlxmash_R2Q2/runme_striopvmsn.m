% Load files: analysisdb.mat, micedb.mat
COLORS = cbrewer('qual', 'Set2', 10);

[groupsStrioMash, namesStrioMash] = groupmice4(micedb, 'Strio', 'Mash');
[datStrioMash, nStrioAnimalsMash] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsStrioMash, 'UniformOutput', false);
[groupsStrioDlx, namesStrioDlx] = groupmice4(micedb, 'Strio', 'Dlx');
[datStrioDlx, nStrioAnimalsDlx] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsStrioDlx, 'UniformOutput', false);

figure;
subplot(1,2,1);
plotbars(datStrioMash, namesStrioMash, COLORS, 'nodots');
xlabel('Groups');
ylabel('# Putative Terminals');
title(['PVMSN - STRIO Mash - CELLS - ' newline ...
    mktitle(namesStrioMash, nStrioAnimalsMash, datStrioMash)]);
subplot(1,2,2);
plotbars(datStrioDlx, namesStrioDlx, COLORS, 'nodots');
xlabel('Groups');
ylabel('# Putative Terminals');
title(['PVMSN - STRIO Dlx - CELLS - ' newline ...
    mktitle(namesStrioDlx, nStrioAnimalsDlx, datStrioDlx)]);

% n = length(namesStrio);
% pairs = nchoosek(1:n,2);
% for i=1:size(pairs,1)
%     a = pairs(i,1);
%     b = pairs(i,2);
%     
%     x = datStrio{a};
%     y = datStrio{b};
%     if isempty(x) || isempty(y)
%         continue;
%     end
%     
%     [~,ttestp] = ttest2(x,y);
%     signrankp = ranksum(x,y);
%     fprintf(['ttest: ' namesStrio{a} ' v ' namesStrio{b} ' p=%.3f \n'], ttestp);
%     fprintf(['signrank: ' namesStrio{a} ' v ' namesStrio{b} ' p=%.3f \n'], signrankp);
% end

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
