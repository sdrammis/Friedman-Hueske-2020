SPIKE_GRADE_THRESH = 0.55;

rewardTone = 1;

[~, sortOrder] = sort({sessions.sessionDate});
sessions = sessions(sortOrder);

n = size(sessions,2);
nSpikes = nan(1,n);
sessionTime = nan(1,n);
for k=1:n
    trialData = sessions(k).trialData;
    trialSpikes = sessions(k).trialSpikes;
    if isempty(trialSpikes)
        continue;
    end
    
    varsDel = {'BurstStartTime', 'BurstNumber'};    
    sessionSpikes = cellfun(@(T) removevars(T,varsDel), trialSpikes, 'UniformOutput', false);
    rewardSpikes = sessionSpikes(trialData.StimulusID == rewardTone);
    spikes = vertcat(rewardSpikes{:});
    goodSpikes = spikes(spikes.Grade >= SPIKE_GRADE_THRESH, :);
    nSpikes(k) = size(goodSpikes,1);
    sessionTime(k) = sum(trialData.ITIEndTime - trialData.TrialStartTime);
end


inj = {};
conctr = {};
deval = {};
dates = {};
spikes = {};
times = {};
prevday = nan;
for jj=1:length(sessions)
    day = sessions(jj).sessionDate;
    if isnan(prevday)
        session = sessions(jj);
        spikes{end+1} = nSpikes(jj);
        times{end+1} = sessionTime(jj);
        inj{end+1} = session.injection;
        conctr{end+1} = session.concentration;
        deval{end+1} = session.devaluation;
        dates{end+1} = weekday(day);
        prevday = day;
        continue;
    end
    
    diff = daysact(prevday, day);
    if diff > 1
        nDays = length(days);
        spikes(end+1:end+diff-1) = {0};
        times(end+1:end+diff-1) = {0};
        inj(end+1:end+diff-1) = {[]};
        conctr(end+1:end+diff-1) = {[]};
        deval(end+1:end+diff-1) = {[]};
        dates(end+1:end+diff-1) = {8};
    end
    session = sessions(jj);
    spikes{end+1} = nSpikes(jj);
    times{end+1} = sessionTime(jj);
    inj{end+1} = session.injection;
    conctr{end+1} = session.concentration;
    deval{end+1} = session.devaluation;
    dates{end+1} = weekday(day);
    prevday = day;
end

%% PLot
subplot(2,1,1);
spikesHZ = cell2mat(spikes) ./ cell2mat(times);
DAYS = {'M', 'T', 'W', 'R', 'F', 'SAT', 'SUN', '-'};
xlabels = cellfun(@(x) DAYS{x}, dates, 'UniformOutput', false);
hold on;
for k=1:length(spikesHZ)
    if strcmp(inj{k}, 'CNO')
       c = [cell2mat(conctr(k)) 0.5 0];
    elseif strcmp(inj{k}, 'Saline')
       c = [0 0 1]; 
    else
       c = [0.9 0.9 0.9];
    end
    
    if strcmp(deval{k}, 'Water')
        e = [0 1 1];
        w = 2;
    elseif strcmp(deval{k}, 'Sucrose')
        e = [1 0.3 0.8];
        w = 2;
    else
        e = [0 0 0];
        w = 1;
    end
    bar(k, spikesHZ(k), 'FaceColor', c, 'EdgeColor', e, 'LineWidth', w);
end
xticks(1:length(spikes));
xticklabels(xlabels);
ylabel('Spike Firing Rate (Hz)');
xlabel('Time (Days)');

h = zeros(7,1);
h(1) = plot(NaN,NaN,'s','Color',[1 0.5 0]);
h(2) = plot(NaN,NaN,'s','Color',[0.6 0.5 0]);
h(3) = plot(NaN,NaN,'s','Color',[0.3 0.5 0]);
h(4) = plot(NaN,NaN,'s','Color',[0 0 1]);
h(5) = plot(NaN,NaN,'s','Color',[0.9 0.9 0.9]);
h(6) = plot(NaN,NaN,'s','Color',[0 1 1]);
h(7) = plot(NaN,NaN,'s','Color',[1 0.3 0.8]);
legend(h, ...
    'CNO 1', 'CNO 0.6', 'CNO 0.3', 'Saline', 'No Injection', 'Water', 'Sucrose', ...
    'Location', 'northwest');

subplot(2,1,2);
prevRatio = [nan];
for k=2:length(spikesHZ)
    prevRatio(end+1) = spikesHZ(k) / spikesHZ(k-1);
end

nextRatio = [];
for k=1:length(spikesHZ)-1
    nextRatio(end+1) = spikesHZ(k) / spikesHZ(k+1);
end
nextRatio(end+1) = nan;

hold on;
plot(prevRatio, '*-');
plot(nextRatio, '*-');
hline(1);
xticks(1:length(spikes));
xticklabels(xlabels);
legend('Ratio to Prev', 'Ratio to Next', 'Location', 'northwest');
ylabel('Ratio to Prev or Next');
xlabel('Time (Days)');


% title_ = [sprintf('Mouse ID = %s, Health = %s, Striosomality = %s', ...
%         mouse.ID, mouse.Health, mouse.intendedStriosomality), ...
%         newline sprintf('DREADDType = %s, genotype = %s, positive = %d', ...
%         mouse.DREADDType, mouse.genotype, mouse.positive)];
% suptitle(title_);
    