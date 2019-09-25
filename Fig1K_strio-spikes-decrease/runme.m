% Load files: light_twdb_2019-08-08_spikes.mat, miceType.mat

PERIOD = 'all';
USE_FIRST_TASK = 1;
ENGAGED = 1;

groupsStrio = groupmice(miceType, 'Strio');
datStrioEng = get_groups_spikes(twdb, groupsStrio, PERIOD, ENGAGED, USE_FIRST_TASK);

f = figure;
[n, dat] = plot_group(datStrioEng{1});
title('Spike Changes Strio Engaged WTL');

x = datStrioEng{1}(:,1);
y = datStrioEng{1}(:,2);
[~,ttestp] = ttest(x,y);
signrankp = signrank(x,y);
fprintf('ttest p = %d \n', ttestp);
fprintf('signrank p = %d \n', signrankp);
fprintf('obsersvation = mouse (# = %d) \n', n);

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

function dat = get_groups_spikes(twdb, groups, period, eng, useFirstTask)
dat = ...
    cellfun(@(group) get_group_spikes(twdb, group, period, eng, useFirstTask), ...
    groups, 'UniformOutput', false);
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