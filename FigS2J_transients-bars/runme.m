% Load files: light_twdb_2019-08-08_spikes.mat, miceType.mat

% PERIOD = 'tone+response';
% USE_FIRST_TASK = 1;
% ENG = 'all';
% 
% groupsStrio = groupmice(miceType, 'Strio');
% groupsMatrix = groupmice(miceType, 'Matrix');
% 
% datStrioNum_ = get_groups_spikes(twdb, groupsStrio, PERIOD, ENG, USE_FIRST_TASK);
% datStrioNum = filter_mice([datStrioNum_{1}; datStrioNum_{2}], [groupsStrio{1} groupsStrio{2}]);
% datMatrixNum_ = get_groups_spikes(twdb, groupsMatrix, PERIOD, ENG, USE_FIRST_TASK);
% datMatrixNum = filter_mice([datMatrixNum_{1}; datMatrixNum_{2}], [groupsMatrix{1} groupsMatrix{2}]);
% datNum = {datStrioNum(:,2), datMatrixNum(:,2)};
% 
datStrioHeights_ = get_groups_spikes_heights(twdb, groupsStrio, PERIOD, ENG, USE_FIRST_TASK);
datStrioHeights = filter_mice([datStrioHeights_{1}; datStrioHeights_{2}], [groupsStrio{1} groupsStrio{2}]);
datMatrixHeights_ = get_groups_spikes_heights(twdb, groupsMatrix, PERIOD, ENG, USE_FIRST_TASK);
datMatrixHeights = filter_mice([datMatrixHeights_{1}; datMatrixHeights_{2}], [groupsMatrix{1} groupsMatrix{2}]);
datHeights = {datStrioHeights(:,2), datMatrixHeights(:,2)};

figure;
subplot(1,2,1);
plotbars(datNum, {'Strio', 'Matrix'}, [1 0 0; 0 0 1]);
title('# Transients');
subplot(1,2,2);
plotbars(datHeights, {'Strio', 'Matrix'}, [1 0 0; 0 0 1]);
title('Transient heights');

x1 = datNum{1};
y1 = datNum{2};
[~,ttestp1] = ttest2(x1,y1);
signrankp1 = ranksum(x1,y1);
nS1 = sum(~isnan(x1));
nM1 = sum(~isnan(y1));
fprintf('# spikes -- ttest p = %d \n', ttestp1);
fprintf('# spikes -- signrank p = %d \n', signrankp1);
fprintf('# strio animals = %d, # matrix animals = %d \n', nS1, nM1);

x2 = datHeights{1};
y2 = datHeights{2};
[~,ttestp2] = ttest2(x2,y2);
signrankp2 = ranksum(x2,y2);
nS2 = sum(~isnan(x2));
nM2 = sum(~isnan(y2));
fprintf('heights spikes -- ttest p = %d \n', ttestp2);
fprintf('heights spikes -- signrank p = %d \n', signrankp2);
fprintf('# strio animals = %d, # matrix animals = %d \n', nS2, nM2);

function ret = filter_mice(dat, mice)
ret = [];
for ii=1:length(mice)
    mouse = mice{ii};
    if mouse.positive == 0
        continue;
    end
    ret = [ret; dat(ii,:)];
end
end

function dat = get_groups_spikes_heights(twdb, groups, period, eng, useFirstTask)
dat = ...
    cellfun(@(group) get_group_spikes_heights(twdb, group, period, eng, useFirstTask), ...
    groups, 'UniformOutput', false);
end

function ret = get_group_spikes_heights(twdb, group, period, eng, useFirstTask)
n = length(group);
avgSpikesStart = nan(1,n);
avgSpikesEnd = nan(1,n);

for ii=1:n
    spikes = get_spike_heights(twdb, group{ii}, period, eng, useFirstTask);
    lgth = length(spikes);
    if lgth < 5
        continue;
    end
    avgSpikesStart(ii) = nanmean(spikes(1:floor(lgth/3)));
    avgSpikesEnd(ii) = nanmean(spikes);
end

ret = [avgSpikesStart' avgSpikesEnd'];
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