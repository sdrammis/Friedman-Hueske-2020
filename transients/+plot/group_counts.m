% Load micetype and twdb.
ENG = 'all';
PERIOD = 'all-no-outcome';
conf = config();

groupsStrio = plot.group.groupmice(miceType, 'Strio');
groupsMatrix = plot.group.groupmice(miceType, 'Matrix');

datStrio = ...
    cellfun(@(group) getgroupdata(twdb, group, PERIOD, ENG), ...
    groupsStrio, 'UniformOutput', false);
datMatrix = ...
    cellfun(@(group) getgroupdata(twdb, group, PERIOD, ENG), ...
    groupsMatrix, 'UniformOutput', false);

figdir = [conf.MICE_FIGS filesep 'corrs_final'];
mkdir(figdir);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
plot_correlations(datStrio);
suptitle(sprintf('Strio, period=%s, eng=%d', PERIOD, ENG));
saveas(f1, [figdir filesep 'strio_period=' PERIOD '_sessions_all.fig']);

f2 = figure('units','normalized','outerposition',[0 0 1 1]);
plot_correlations(datMatrix);
suptitle(sprintf('Matrix, period=%s, eng=%d', PERIOD, ENG));
saveas(f2, [figdir filesep 'matrix_period=' PERIOD '_sessions_all.fig']);

function plot_correlations(groups)
datAll = cellfun(@(group) getdat_mouse(group, 'all'), groups, 'UniformOutput', false);
datSpikes = cellfun(@(dat) [dat.spikeRates], datAll, 'UniformOutput', false);
datDPrime = cellfun(@(dat) [dat.dprimes], datAll, 'UniformOutput', false);
datC = cellfun(@(dat) [dat.cs], datAll, 'UniformOutput', false);
datLicks = cellfun(@(dat) [dat.licksZ], datAll, 'UniformOutput', false);

subplot(3,4,1);
plot_corr(datSpikes{1}, datLicks{1}, 'WTL', 'Licks');
subplot(3,4,2);
plot_corr(datSpikes{2}, datLicks{2}, 'WTNL', 'Licks');
subplot(3,4,3);
plot_corr(datSpikes{3}, datLicks{3}, 'HDL', 'Licks');
subplot(3,4,4);
plot_corr(datSpikes{4}, datLicks{4}, 'HDNL', 'Licks');

subplot(3,4,5);
plot_corr(datSpikes{1}, datDPrime{1}, 'WTL', 'DPrime');
subplot(3,4,6);
plot_corr(datSpikes{2}, datDPrime{2}, 'WTNL', 'DPrime');
subplot(3,4,7);
plot_corr(datSpikes{3}, datDPrime{3}, 'HDL', 'DPrime');
subplot(3,4,8);
plot_corr(datSpikes{4}, datDPrime{4}, 'HDNL', 'DPrime');

subplot(3,4,9);
plot_corr(datSpikes{1}, datC{1}, 'WTL', 'C');
subplot(3,4,10);
plot_corr(datSpikes{2}, datC{2}, 'WTNL', 'C');
subplot(3,4,11);
plot_corr(datSpikes{3}, datC{3}, 'HDL', 'C');
subplot(3,4,12);
plot_corr(datSpikes{4}, datC{4}, 'HDNL', 'C');
end

function plot_corr(spikes, other, title_, xlabel_)
idxs = ~(isnan(spikes) | isnan(other));
y_overall = spikes(idxs);
x_overall = other(idxs);
bin_width = 1;

begin = round(min(x_overall),1)-0.1;
if rem(begin,bin_width)
    begin = begin-0.1;
end
ending = round(max(x_overall),1)+0.1;
if rem(ending,bin_width)
    ending = ending+0.1;
end
x = begin:bin_width:ending;
byDP = cell(1,length(x)-1);
for n=1:length(x)-1
    byDP{n} = [byDP{n} y_overall(and(x_overall<x(n+1),x_overall>=x(n)))];
end
%Parameters for Striosomal Z-scores
y = cellfun(@nanmean,byDP); %Z-Score mean per bin
y_std = cellfun(@nanstd,byDP); %Z-score STD per bin
len = cellfun(@length,byDP); %Amount of datapoints per bin
%Removes bins w/o datapoints
thresh = 1;
x = x(len>thresh);
y = y(len>thresh);
y_std = y_std(len>thresh);
len = len(len>thresh);
y_err = y_std./sqrt(len);
%For amount of datapoints
color_str = {[1 1 0],[1 0.5 0],[1 0 0]};
%Linear Regression and Correlation
[~,m1,b1]=regression(x,y);
% fittedX=min(x-x_error):0.01:max(x_error+x);
fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
fittedY=fittedX*m1+b1;
cor1 = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval = P(2);
else
    pval = P;
end
hold on
plot(fittedX+(bin_width/2),fittedY,'k','LineWidth',3);%Plots line of best fit
errorbar(x+(bin_width/2),y,y_err,'.k')
for n=1:length(x)%Plots each point indicating amount of datapoints per bin
    if floor(log10(len(n))+1)==1
        p(1) = plot(x(n)+(bin_width/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    elseif floor(log10(len(n))+1)==2
        p(2) = plot(x(n)+(bin_width/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    elseif floor(log10(len(n))+1)==3
        p(3) = plot(x(n)+(bin_width/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    end
end
xlabel(xlabel_)
ylabel('Spike Rate Diff')
title({title_, ['Mean of Bins, Bin Size = ' num2str(bin_width)],...
    ['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)]})
axis tight

% 
% idxs = ~(isnan(spikes) | isnan(other));
% x = spikes(idxs);
% y = other(idxs);
% [~,slope,b1] = regression(x,y);
% fittedX = (min(x)-0.000001):0.000001:(max(x)+0.000001);
% fittedY = fittedX*slope + b1;
% R = corr2(x,y);
% [~,P] = corrcoef(x,y);
% if size(P,1) == 1
%     pval = P;
% else
%     pval = P(2);
% end
% hold on;
% plot(x,y,'ok')
% plot(fittedX,fittedY,'k','LineWidth',3);
% xlabel('Spike Rate Diff (Reward - Cost)');
% ylabel(xlabel_)
% title({title_, ['m=',num2str(slope),'/cor=',num2str(R),'/p=',num2str(pval)]})
end

function ret = getdat_mouse(group, learning)
ret = {};
for ii=1:length(group)
    mousedat = group{ii};
    n = length(mousedat.spikeRates);
    
    switch (learning)
        case 'early'
            s = 1;
            t = floor(n*(1/3));
        case 'mid'
            s = floor(n*(1/3))+1;
            t = floor(n*(2/3));
        case 'late'
            s = floor(n*(2/3))+1;
            t = n;
        case 'all'
            s = 1;
            t = n;
    end
    
    licks = mousedat.licks(s:t);
    spikeRates = mousedat.spikeRates(s:t);
    dprimes = mousedat.dprimes(s:t);
    cs = mousedat.cs(s:t);
    idxKeep = ~isnan(licks) & ~isnan(spikeRates) & ~isnan(dprimes) & ~isnan(cs);
    
    ret(ii).spikeRates = zscore(spikeRates(idxKeep));
    ret(ii).dprimes = dprimes(idxKeep);
    ret(ii).cs = cs(idxKeep);
    ret(ii).licksZ = zscore(licks(idxKeep));
%         ret(ii).spikeRates = mean(spikeRates(idxKeep));
%         ret(ii).dprimes = mean(dprimes(idxKeep));
%         ret(ii).cs = mean(cs(idxKeep));
%         ret(ii).licksZ = mean(licks(idxKeep));
end
end

function ret = getgroupdata(twdb, group, period, eng)
ret = {};
for i=1:length(group)
    mouse = group{i};
    [spikeRates_, dprimes_, cs_, licks_] = get_spikes(twdb, mouse, period, eng);
    if isempty(spikeRates_)
        continue;
    end
    s.spikeRates = spikeRates_;
    s.dprimes = dprimes_;
    s.licks = licks_;
    s.cs = cs_;
    ret{end+1} = s;
end
end

function [spikeRates, dprimes, cs, licks] = get_spikes(twdb, mouse, period, eng)
TONE_DURATION = 2000;
SPIKE_GRADE_THRESH = 0.55;
USE_FIRST_TASK = 1;

sessionIdxs = utils.get_mouse_sessions(twdb, mouse.ID, USE_FIRST_TASK, 0, 'all', 0);
sessions = twdb(sessionIdxs);
[~, sortOrder] = sort({sessions.sessionDate});
sessions = sessions(sortOrder);

firstSessionType = first(twdb_lookup(twdb,'firstSessionType','key','mouseID',mouse.ID));
if strcmp(firstSessionType, 'tt')
    rewardTone = 1;
    costTone = 2;
else
    rewardTone = 2;
    costTone = 1;
end

n = size(sessions,2);
spikeRates = nan(1,n);
dprimes = nan(1,n);
cs = nan(1,n);
licks = nan(1,n);
for ii=1:n
    trialData = sessions(ii).trialData;
    trialSpikes = sessions(ii).trialSpikes;
    if isempty(trialSpikes) || ~ismember('Engagement', trialData.Properties.VariableNames)
        continue;
    end
    
    if ~strcmp(eng, 'all')
        engIdxs = trialData.Engagement == eng;
        trialData = trialData(engIdxs,:);
        trialSpikes = trialSpikes(engIdxs);
        if isempty(trialSpikes)
            continue;
        end
    end
    
    trialData.LicksInResponse = trialData.ResponseLickFrequency;
    [~, ~, dprimes(ii), cs(ii)] = utils.dprime_and_c(trialData, rewardTone, costTone);
    licksReward = nanmean(trialData.ResponseLickFrequency(trialData.StimulusID == rewardTone));
    licksCost = nanmean(trialData.ResponseLickFrequency(trialData.StimulusID == costTone));
    licks(ii) = licksReward - licksCost;
    
    switch period
        case 'all-no-outcome'
            s = trialData.TrialStartTime;
            t = trialData.OutcomeStartTime;
        case 'all'
            s = trialData.TrialStartTime;
            t = trialData.ITIEndTime;
        case 'tone'
            s = trialData.ToneStartTime;
            t = trialData.ToneStartTime + TONE_DURATION;
        case 'response'
            s = trialData.ToneStartTime + TONE_DURATION;
            t = trialData.OutcomeStartTime;
        case 'outcome+ITI'
            s = trialData.OutcomeStartTime;
            t = trialData.OutcomeStartTime + 10000;
    end
    
    nSpikesReward = 0;
    timeReward = 0;
    nSpikesCost = 0;
    timeCost = 0;
    for jj=1:length(trialSpikes)
        if isempty(trialSpikes{jj})
            continue;
        end
        
        spikes = removevars(trialSpikes{jj}, {'BurstStartTime', 'BurstNumber'});
        cleanSpikes = spikes(spikes.Grade >= SPIKE_GRADE_THRESH, :);
        periodSpikes = cleanSpikes(cleanSpikes.PeakTime >= s(jj) & cleanSpikes.PeakTime <= t(jj),:);
        
        if trialData{jj,'StimulusID'} == rewardTone
            nSpikesReward = nSpikesReward + size(periodSpikes,1);
            timeReward = timeReward + t(jj) - s(jj);
        else
            nSpikesCost = nSpikesCost + size(periodSpikes,1);
            timeCost = timeCost + t(jj) - s(jj);
        end
    end
    spikeRates(ii) = (nSpikesReward / timeReward) - (nSpikesCost / timeCost);
end
end