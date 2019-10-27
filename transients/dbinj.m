% load('../dbs/light_twdb_2019-07-26.mat');
conf = config();

files = dir([conf.GRADES_DIR filesep '*.mat']);

for iFile=1:size(files,1)
    file = files(iFile);
    fname = file.name;
    
    fprintf('Progress %d/%d ... \n', iFile, size(files,1));
    
    varnames = {'trialIDX', 'StartTime', 'PeakTime', 'Grade', 'Group'};
    trialSpikes = table(0, 0, 0, 0, 0, 'VariableNames', varnames);
    
    splits = strsplit(strrep(fname, '.mat', ''), '_');
    row = str2double(splits{2}(4:end));
    mouseID = splits{3}(2:end);
    taskType = splits{4};
    sessionNum = str2double(splits{5}(2:end));
    
    session = twdb(row);
    % Check that row is correct.
    if ~(strcmp(session.mouseID, mouseID) ...
            && session.sessionNumber == sessionNum ...
            && strcmp(session.taskType, taskType))
        msg = sprintf('File %s does not match with database values', fname);
        throw(MException('dbinj:invalidFile', msg));
    end
    
    load([conf.GRADES_DIR filesep fname]);
    spikeTimes = [sessionSpikes{:,1}];
    trialsData = session.trialData;
    if isempty(trialsData)
        continue;
    end
    
    for iTrial = 1:height(trialsData)
        trialStart = trialsData{iTrial,'TrialStartTime'};
        trialEnd = trialsData{iTrial, 'ITIEndTime'};
        trialSpikeIdx = find(spikeTimes(spikeTimes <= trialEnd) >= trialStart);        
        if isempty(trialSpikeIdx)
            continue;
        end
        
        spikesInTrial = cell(length(trialSpikeIdx),length(varnames));
        spikesInTrial(:,1) = {iTrial};
        spikesInTrial(:,2:5) = sessionSpikes(trialSpikeIdx,[1 2 3 5]);
        trialSpikes = [trialSpikes; cell2table(spikesInTrial, 'VariableNames', varnames)];
    end
    twdb(row).trialSpikes = trialSpikes(2:end,:);
end
