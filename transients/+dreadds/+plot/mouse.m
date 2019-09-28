function mouse(nSpikes, sessionTime, sessions)
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

spikesHZ = cell2mat(spikes) ./ cell2mat(times);
DAYS = {'S', 'M', 'T', 'W', 'R', 'F', 'S', '-'};
xlabels = cellfun(@(x, i) DAYS{x}, dates, 'UniformOutput', false);

subplot(2,1,1);
hold on;
for k=1:length(spikesHZ)
    if strcmp(inj{k}, 'CNO')
       c = [cell2mat(conctr(k)) 0.5 0];
    elseif strcmp(inj{k}, 'Saline')
       c = [0 0 1];
    elseif strcmp(inj{k}, 'Apomorphine')
        c = [cell2mat(conctr(k)) 0 0];
    elseif strcmp(inj{k}, 'CNO + Apomorphine')
        conctr_ = conctr{k};
        c = [0.33 0 conctr_(1)/3];
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
ylabel('Spike Firing Rate (Hz -- # spikes / ms)');
xlabel('Time - In Days');
xlim([-10 length(spikes)+1]);

h = zeros(12,1);
h(1) = patch(NaN,NaN,[1 0.5 0]);
h(2) = patch(NaN,NaN,[0.6 0.5 0]);
h(3) = patch(NaN,NaN,[0.3 0.5 0]);
h(4) = patch(NaN,NaN,[0 0 1]);
h(5) = patch(NaN,NaN,[0.9 0.9 0.9]);
h(6) = patch(NaN,NaN,[0 1 1]);
h(7) = patch(NaN,NaN,[1 0.3 0.8]);
h(8) = patch(NaN,NaN,[1 0 0]);
h(9) = patch(NaN,NaN,[0.5 0 0]);
h(10) = patch(NaN,NaN,[0.33 0 1]);
h(11) = patch(NaN,NaN,[0.33 0 0.33]);
h(12) = patch(NaN,NaN,[0.33 0 0.1]);

legend(h, ...
    'CNO 1', 'CNO 0.6', 'CNO 0.3', 'Saline', 'No Injection', ...
    'Water', 'Sucrose', ...
    'Apo 1', 'Apo 0.5', ...
    'CNO 0.3 + Apo 0.5', 'CNO 0.3 + Apo 1', ' CNO 0.3 + Apo 3', ...
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
legend('Ratio to Prev', 'Ratio to Next');
ylabel('Ratio to Prev or Next');
xlabel('Time (Days)');
end
