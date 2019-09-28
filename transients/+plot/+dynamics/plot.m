conf = config();
PERIODS = {'all', 'tone', 'response', 'outcome+ITI'};
USE_FIRST_TASK = 0;

for ii=1:length(PERIODS)
    period = PERIODS{ii};
    fprintf(['Running period... ' period '\n']);
    
    groupsStrio = plot.group.groupmice(miceType, 'Strio');
    groupsMatrix = plot.group.groupmice(miceType, 'Matrix');
    
    whenEngaged = 1;
    datStrioAll = get_groups_spikes(twdb, groupsMatrix, period, 'all', USE_FIRST_TASK);
    datStrioEng = get_groups_spikes(twdb, groupsStrio, period, whenEngaged, USE_FIRST_TASK);
    datStrioNeng = get_groups_spikes(twdb, groupsStrio, period, ~whenEngaged, USE_FIRST_TASK);
    datMatrixAll = get_groups_spikes(twdb, groupsMatrix, period, 'all', USE_FIRST_TASK);
    datMatrixEng = get_groups_spikes(twdb, groupsMatrix, period, whenEngaged, USE_FIRST_TASK);
    datMatrixNeng = get_groups_spikes(twdb, groupsMatrix, period, ~whenEngaged, USE_FIRST_TASK);
    
    figdir = [conf.MICE_FIGS filesep 'dynamics_prop_t1_reversal'];
    mkdir(figdir);
    f1 = plot_do(datStrioAll, datStrioEng, datStrioNeng);
    suptitle(sprintf('Strio, period=%s', period));
    saveas(f1, [figdir filesep 'strio_period=' period '.png']);
    saveas(f1, [figdir filesep 'strio_period=' period '.fig']);
    f2 = plot_do(datMatrixAll, datMatrixEng, datMatrixNeng);
    suptitle(sprintf('Matrix, period=%s', period));
    saveas(f2, [figdir filesep 'matrix_period=' period '.png']);
    saveas(f2, [figdir filesep 'matrix_period=' period '.fig']);
    close all;
end

function f = plot_do(datAll, datEng, datNeng)
f = figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(3,5,1);
plot_groups(datEng);
title('Engaged - Group Avg');
ax2 = subplot(3,5,2);
plot_group(datEng{1});
title(sprintf('Engaged - WTL (P=%.3f)', utils.ttestp(datEng{1}(:,1), datEng{1}(:,2))));
ax3 = subplot(3,5,3);
plot_group(datEng{2});
title(sprintf('Engaged - WTNL (P=%.3f)', utils.ttestp(datEng{2}(:,1), datEng{2}(:,2))));
ax4 = subplot(3,5,4);
plot_group(datEng{3});
title(sprintf('Engaged - HDL (P=%.3f)', utils.ttestp(datEng{3}(:,1), datEng{3}(:,2))));
ax5 = subplot(3,5,5);
plot_group(datEng{3});
title(sprintf('Engaged - HDNL (P=%.3f)', utils.ttestp(datEng{4}(:,1), datEng{4}(:,2))));

ax6 = subplot(3,5,6);
plot_groups(datNeng);
title('N-engaged - Group Avg');
ax7 = subplot(3,5,7);
plot_group(datNeng{1});
title(sprintf('N-ngaged - WTL (P=%.3f)', utils.ttestp(datNeng{1}(:,1), datNeng{1}(:,2))));
ax8 = subplot(3,5,8);
plot_group(datNeng{2});
title(sprintf('N-ngaged - WTNL (P=%.3f)', utils.ttestp(datNeng{2}(:,1), datNeng{2}(:,2))));
ax9 = subplot(3,5,9);
plot_group(datNeng{3});
title(sprintf('N-ngaged - HDL (P=%.3f)', utils.ttestp(datNeng{3}(:,1), datNeng{3}(:,2))));
ax10 = subplot(3,5,10);
plot_group(datNeng{3});
title(sprintf('N-ngaged - HDNL (P=%.3f)', utils.ttestp(datNeng{4}(:,1), datNeng{4}(:,2))));

ax11 = subplot(3,5,11);
plot_groups(datAll);
title('All - Group Avg');
ax12 = subplot(3,5,12);
plot_group(datAll{1});
title(sprintf('All - WTL (P=%.3f)', utils.ttestp(datAll{1}(:,1), datAll{1}(:,2))));
ax13 = subplot(3,5,13);
plot_group(datAll{2});
title(sprintf('All - WTNL (P=%.3f)', utils.ttestp(datAll{2}(:,1), datAll{2}(:,2))));
ax14 = subplot(3,5,14);
plot_group(datAll{3});
title(sprintf('All - HDL (P=%.3f)', utils.ttestp(datAll{3}(:,1), datAll{3}(:,2))));
ax15 = subplot(3,5,15);
plot_group(datAll{4});
title(sprintf('All - HDNL (P=%.3f)', utils.ttestp(datAll{4}(:,1), datAll{4}(:,2))));

linkaxes([ax1,ax6,ax11],'y')
% linkaxes([ax2,ax3,ax4,ax5,ax7,ax8,ax9,ax10,ax12,ax13,ax14,ax15],'y')
end

function plot_group(dat)
hold on;
spikes = dat(~(isnan(dat(:,1)) | isnan(dat(:,2))),:);
for ii=1:size(spikes,1)
    plot([1 2], spikes(ii,:), 'k*-');
end
ylabel('Spike Rate');
xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'Start', 'End'});
end

function plot_groups(datGroups)
hold on;
for k=1:length(datGroups)
    dat =  datGroups{k};
    y = nanmean(dat,1);
    err = [utils.std_error(dat(:,1)) utils.std_error(dat(:,2))];
    errorbar(y,err);
end
ylabel('Spike Rate');
xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'Start', 'End'});
legend('WTL', 'WTNL', 'HDL', 'HDNL');
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
    spikes = plot.dynamics.get_spikes(twdb, group{ii}, period, eng, useFirstTask);
    
    %     if isempty(spikes) || length(spikes) < 10
    %         continue;
    %     end
    %     avgSpikesStart(ii) = nanmean(spikes(1:5));
    %     avgSpikesEnd(ii) = nanmean(spikes(end-5:end));
    
    lgth = length(spikes)
    if length(spikes) < 5
        continue;
    end
    avgSpikesStart(ii) = nanmean(spikes(1:floor(lgth/3)));
    avgSpikesEnd(ii) = nanmean(spikes(floor(2*lgth/3):end));
end

ret = [avgSpikesStart' avgSpikesEnd'];
end