function ret = analyze_mouse(cal, mouseID, typeDREADD)
varNames = {'MouseID', 'SpikesHZ', 'TaskTypes', 'SessionNums', 'SessionNumCNO', 'SessionNumSaline', 'ConctrCNO', 'SpikeRateDiff', 'Effect'};
ret = table({''}, {[]}, {[]}, {[]}, 0, 0, 0, 0, {''}, 'VariableNames', varNames);

binstr = strrep([num2str(cal.didRun')], '  ', '');
[~,s] = regexp(binstr,'01');
[t,~] = regexp(binstr,'10');
for ii=1:length(s)
    group = cal(s(ii):t(ii),:);
    
    sessionsSaline = group(strcmp(group.Injection,'Saline'),:);
    sessionsCNO = group(strcmp(group.Injection,'CNO'),: );
    if isempty(sessionsCNO) || size(group,1) < 2
        continue;
    end

    % Ignore groups with Apomorphine session
    sessionsApo = group(strcmp(group.Injection,'Apomorphine'),: );
    sessionsApoCNO = group(strcmp(group.Injection,'CNO + Apomorphine'),: );
    if ~isempty(sessionsApo) || ~isempty(sessionsApoCNO)
        continue;
    end
    
    spikesCNO = sessionsCNO{1,'SpikesHZ'};
    diffBest = tern(strcmp(typeDREADD, 'Inhibitory'), Inf, -Inf);
    idxBest = 0;
    for jj=1:size(sessionsSaline,1)
        spikesSaline = sessionsSaline{jj,'SpikesHZ'};
        diff = spikesCNO - spikesSaline;
        if diff < diffBest && strcmp(typeDREADD, 'Inhibitory')
            idxBest = jj;
            diffBest = diff;
        elseif diff > diffBest && strcmp(typeDREADD, 'Excitatory')
            idxBest = jj;
            diffBest = diff;
        end
    end
    if idxBest == 0
        continue;
    end
    
    spikesHZ = [group.SpikesHZ];
    taskTypes = {group.TaskType};
    sessionNums = [group.SessionNumber];
    sessionNumCNO = sessionsCNO{1,'SessionNumber'};
    sessionNumSaline = sessionsSaline{idxBest,'SessionNumber'};
    conctrCNO = sessionsCNO{1,'Concentration'};
    spikeRateDiff = diffBest;
    effect = find_effect(group, typeDREADD, spikesCNO);
    ret = [ret; {mouseID, spikesHZ, taskTypes, sessionNums, sessionNumCNO, sessionNumSaline, conctrCNO, spikeRateDiff, effect}];
end
ret(1,:) = [];
end

function effect = find_effect(group, typeDREADD, spikesCNO)
idxCNO = find(strcmp(group.Injection,'CNO'));
if idxCNO + 1 > size(group,1) || idxCNO - 1 < 1
    effect = 'unknown';
else
    prevSpikes = group{idxCNO-1,'SpikesHZ'};
    nextSpikes = group{idxCNO+1,'SpikesHZ'};
    if strcmp(typeDREADD, 'Inhibitory')
        if prevSpikes > spikesCNO && nextSpikes > spikesCNO
            effect = 'short';
        elseif prevSpikes > spikesCNO && nextSpikes < spikesCNO
            effect = 'long';
        else
            effect = 'unknown';
        end
    elseif strcmp(typeDREADD, 'Excitatory')
        if prevSpikes < spikesCNO && nextSpikes < spikesCNO
            effect = 'short';
        elseif prevSpikes < spikesCNO && nextSpikes > spikesCNO
            effect = 'long';
        else
            effect = 'unknown';
        end
    end
end
end

