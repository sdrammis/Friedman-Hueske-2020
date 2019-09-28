load('../dbs/micedb.mat');
% load('../dbs/twdb_here.mat');

conf = config();

PERIOD = 'outcome+ITI';
ENG = 1;
for iMice=1:size(micedb,2)
    mouse = micedb(iMice);
    data = load([conf.MICE_DIR filesep mouse.ID '.mat']);
    
    figdir = [conf.MICE_FIGS filesep 'plots_mice_indv_period=' PERIOD '_eng=' num2str(ENG)];
    mkdir(figdir);
    
    f1 = figure('units','normalized','outerposition',[0 0 1 1]);
    plot_(mouse, data.trialsTask1, PERIOD, ENG);
    saveas(f1, [figdir filesep mouse.ID '.png']);

    f2 = figure('units','normalized','outerposition',[0 0 1 1]);
    plot_(mouse, data.trialsTask2, PERIOD, ENG);
    saveas(f2, [figdir filesep mouse.ID '_reversal.png']);
    
    close all;
end

function plot_(mouse, data, period, eng)
plot_period(data, period, eng);
t = sprintf('Mouse ID=%s, %s, %s, Learned=%d, Age=%d', ...
    mouse.ID, mouse.Health, mouse.intendedStriosomality, ...
    mouse.learnedFirstTaskSessions, mouse.firstSessionAge);
title(t);
end

function plot_period(data, period, eng)
% TODO for now only looking at big spikes
[avgSpikesT1, avgSpikesT2, dprime, avgLicksT1, avgLicksT2] = ...
    batch(data.bigSpikes, data.trialData, data.rewardTones, period, eng);
t1 = round(length(avgSpikesT1) / 3);
t2 = t1 * 2;

if t1 == 0
    return;
end

subplot(2,3,1);
hold on;
plot(avgSpikesT1);
plot(avgSpikesT2);
plot(avgSpikesT1 + avgSpikesT2);
legend('T1', 'T2', 'All');
xlabel('Sessions');
ylabel('Spike Rate');

subplot(2,3,2);
hold on;
scatter(avgSpikesT1(1:t1), dprime(1:t1));
scatter(avgSpikesT2(1:t1), dprime(1:t1));
legend('T1', 'T2')
xlabel('Spike Rate - First Third');
ylabel('d-Prime');

subplot(2,3,3);
hold on;
scatter(avgSpikesT1(t2:end), dprime(t2:end));
scatter(avgSpikesT2(t2:end), dprime(t2:end));
legend('T1', 'T2')
xlabel('Spike Rate - Last Third');
ylabel('d-Prime');

subplot(2,3,4);
hold on;
scatter(avgSpikesT1, avgLicksT1);
scatter(avgSpikesT2, avgLicksT2);
legend('T1', 'T2');
xlabel('Spike Rate - All');
ylabel('Licks');

subplot(2,3,5);
hold on;
scatter(avgSpikesT1(1:t1), avgLicksT1(1:t1));
scatter(avgSpikesT2(1:t1), avgLicksT2(1:t1));
legend('T1', 'T2');
xlabel('Spike Rate - First Third');
ylabel('Licks');

subplot(2,3,6);
hold on;
scatter(avgSpikesT1(t2:end), avgLicksT1(t2:end));
scatter(avgSpikesT2(t2:end), avgLicksT2(t2:end));
legend('T1', 'T2');
xlabel('Spike Rate - Last Third');
ylabel('Licks');
end

function [spikesT1, spikesT2, dprimes, licksT1, licksT2] = ...
    batch(spikes, trialData, rewardTones, period, eng)
n = length(spikes);
spikesT1 = nan(1,n);
spikesT2 = nan(1,n);
dprimes = nan(1,n);
licksT1 = nan(1,n);
licksT2 = nan(1,n);

for iTrial=1:length(spikes)
    sessionSpikeTimes = spikes{iTrial};
    sessionTrialData = trialData{iTrial};
    rewardTone = rewardTones(iTrial);
    if isempty(sessionSpikeTimes)
        continue;
    end
    
    for spikeTimes=sessionSpikeTimes
        [seshSpikesT1Avg, seshSpikesT2Avg, seshDPrimes, seshLicksT1, seshLicksT2] = ...
            get_spikes(spikeTimes, sessionTrialData, rewardTone, period, eng);     
        spikesT1(iTrial) = seshSpikesT1Avg;
        spikesT2(iTrial) = seshSpikesT2Avg;
        dprimes(iTrial) = seshDPrimes;
        licksT1(iTrial) = seshLicksT1;
        licksT2(iTrial) = seshLicksT2;
    end
end
end

function [avgSpikesT1, avgSpikesT2, dprime, avgLicksT1, avgLicksT2] = ...
    get_spikes(spikeTimes, trialData, rewardStimulus, period, eng)
TONE_DURATION = 2000;

if ~strcmp(eng, 'all')
    trialData = trialData(trialData.Engagement == eng,:);
end

numSpikesT1 = 0;
numSpikesT2 = 0;
switch period
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
        t = trialData.ITIEndTime;
    % TODO other cases
end

for iSpike=1:length(spikeTimes)
    spikeTime = spikeTimes(iSpike);
    trialIdx = find(spikeTime >= s & spikeTime <= t);
    if isempty(trialIdx)
        continue;
    end
    
    if trialData.StimulusID(trialIdx) == rewardStimulus
        numSpikesT1 = numSpikesT1 + 1;
    else
        numSpikesT2 = numSpikesT2 + 2;
    end
end

trialsT1 = trialData.StimulusID == rewardStimulus;
trialsT2 = trialData.StimulusID ~= rewardStimulus;

times = t - s;
timeT1 = sum(times(trialsT1));
timeT2 = sum(times(trialsT2));

avgSpikesT1 = numSpikesT1 / timeT1;
avgSpikesT2 = numSpikesT2 / timeT2;

trialData.LicksInResponse = 2 * trialData.ResponseLickFrequency;
% TODO check this is alway 1 and 2
[~, ~, dprime, ~] = utils.dprime_and_c(trialData, 1, 2);

licksT1 = sum(trialData.ResponseLickFrequency(trialsT1));
licksT2 = sum(trialData.ResponseLickFrequency(trialsT2));
avgLicksT1 = licksT1 / sum(trialsT1);
avgLicksT2 = licksT2 / sum(trialsT2);
end
