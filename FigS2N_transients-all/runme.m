% Load files: light_twdb_2019-08-08_spikes.mat, miceType.mat

PERIOD = 'all';
USE_FIRST_TASK = 1;

groupsStrio = groupmice(miceType, 'Strio');
groupsMatrix = groupmice(miceType, 'Matrix');

datStrioAll = get_group_spikes(twdb, groupsStrio{1}, PERIOD, 'all', USE_FIRST_TASK);
datMatrixAll = get_group_spikes(twdb, groupsMatrix{1}, PERIOD, 'all', USE_FIRST_TASK); 

figure;
ax1 = subplot(1,2,1);
[nStrio, spikesStrio] = plot_group(datStrioAll);
title(sprintf('Strio, period=%s', PERIOD));
ax2 = subplot(1,2,2);
[nMatrix, spikesMatrix] = plot_group(datMatrixAll);
title(sprintf('Matrix, period=%s', PERIOD));
linkaxes([ax1,ax2],'y')

x1 = spikesStrio(:,1);
y1 = spikesStrio(:,2);
[~,ttestp1] = ttest(x1,y1);
signrankp1 = signrank(x1,y1);
fprintf('strio ttest p = %d \n', ttestp1);
fprintf('strio signrank p = %d \n', signrankp1);
fprintf('strio obsersvation = mouse (# = %d) \n', nStrio);

x2 = spikesMatrix(:,1);
y2 = spikesMatrix(:,2);
[~,ttestp2] = ttest(x2,y2);
signrankp2 = signrank(x2,y2);
fprintf('matrix ttest p = %d \n', ttestp2);
fprintf('matrix signrank p = %d \n', signrankp2);
fprintf('matrix obsersvation = mouse (# = %d) \n', nMatrix);

function [n, spikes] = plot_group(dat)
hold on;
spikes = dat(~(isnan(dat(:,1)) | isnan(dat(:,2))),:);
n = size(spikes,1);

for ii=1:n
    plot([1 2], spikes(ii,:), 'k*-');
end
ylabel('Spike Rate');
xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'Start', 'End'});
end

function ret = get_group_spikes(twdb, group, period, eng, useFirstTask)
n = length(group);
avgSpikesStart = nan(1,n);
avgSpikesEnd = nan(1,n);

for ii=1:n
    spikes = get_spikes(twdb, group{ii}, period, eng, useFirstTask);
    
    lgth = length(spikes);
    if length(spikes) < 5
        continue;
    end
    avgSpikesStart(ii) = nanmean(spikes(1:floor(lgth/3)));
    avgSpikesEnd(ii) = nanmean(spikes(floor(2*lgth/3):end));
end

ret = [avgSpikesStart' avgSpikesEnd'];
end