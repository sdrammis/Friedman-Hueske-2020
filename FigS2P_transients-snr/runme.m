% Load files: miceType.mat, light_twdb_2019-08-08_spikes-heights.mat

USE_FIRST_TASK = 1;
ENGAGED = 1;
PERIOD = 'response';

[groups_matrix, names] = groupmice(miceType, 'Matrix');
[groups_strio, ~] = groupmice(miceType, 'Strio');

snrs_matrix = get_groups_spikes(twdb, groups_matrix, PERIOD, ENGAGED, USE_FIRST_TASK);
snrs_strio = get_groups_spikes(twdb, groups_strio, PERIOD, ENGAGED, USE_FIRST_TASK);

snrs_matrix_WTL = snrs_matrix{1};
snrs_strio_WTL = snrs_strio{1};

diffs_matrix = snrs_matrix_WTL(:,2) - snrs_matrix_WTL(:,1);
diffs_strio = snrs_strio_WTL(:,2) - snrs_strio_WTL(:,1);

figure;
subplot(1,2,1);
[nStrio,datStrio] = plot_group(snrs_strio_WTL);
subplot(1,2,2);
[nMatrix,datMatrix] = plot_group(snrs_matrix_WTL);

fprintf('======== strio stats =========');
x = datStrio(:,1);
y = datStrio(:,2);
[~,ttestp] = ttest(x,y);
signrankp = signrank(x,y);
fprintf('ttest p = %d \n', ttestp);
fprintf('signrank p = %d \n', signrankp);
fprintf('obsersvation = mouse (# = %d) \n', nStrio);

fprintf('======== matrix stats =========');
x = datMatrix(:,1);
y = datMatrix(:,2);
[~,ttestp] = ttest(x,y);
signrankp = signrank(x,y);
fprintf('ttest p = %d \n', ttestp);
fprintf('signrank p = %d \n', signrankp);
fprintf('obsersvation = mouse (# = %d) \n', nMatrix);

function [n, spikes] = plot_group(dat)
hold on;
spikes = dat(~(isnan(dat(:,1)) | isnan(dat(:,2)) | isinf(dat(:,1)) | isinf(dat(:,2))), :);
n = size(spikes,1);

for ii=1:n
    plot([1 2], spikes(ii,:), 'k*-');
end
ylabel('vars(spike times) / mean(spike heights)');
xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'Start', 'End'});
end

function dat = get_groups_spikes(twdb, groups, period, eng, useFirstTask)
dat = ...
    cellfun(@(group) get_group_snr(twdb, group, period, eng, useFirstTask), ...
    groups, 'UniformOutput', false);
end

function ret = get_group_snr(twdb, group, period, eng, useFirstTask)
n = length(group);
snrsStart = nan(1,n);
snrsEnd = nan(1,n);

for ii=1:n
    [spikes,heights] = get_spikes_heights_twdb(twdb, group{ii}, period, eng, useFirstTask);
    if length(spikes) < 400
        continue;
    end
        
    spikesStart = spikes(1:250);
    spikesEnd = spikes(end-150:end);
    heightsStart = heights(1:250);
    heightsEnd = heights(end-150:end);

    snrsStart(ii) = (var([spikesStart{:}]) / 1000) / (mean(vertcat(heightsStart{:})));
    snrsEnd(ii) = (var([spikesEnd{:}]) / 1000) / (mean(vertcat(heightsEnd{:})));
end

ret = [snrsStart' snrsEnd'];
end
