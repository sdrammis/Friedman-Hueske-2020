% Given the photometry spike extraction output, this script will
% classify the spikes and grade them as spike/noise and big/small
%
% goldSpikes: a set of patterns that are known to be spikes
% extractedSpikesPath: path to the photometry spike extraction output
% outputFolder: location for spike grading files to be written
%
% output file format --
%   [start time, peak time, grade, burst start time, 1 if big else 0]

% Load the config and necessary data files.
conf = config();
addpath(genpath('./lib'));
load('./data/goldSpikes', 'goldSpikes');
% load('./dbs/light_twdb_2019-07-26.mat');
load('../dbs/micedb');

BATCH_SIZE = 1000;
BUFFER_BEFORE_PEAK = 10;
BUFFER_AFTER_PEAK = 10;
peakIdx = BUFFER_BEFORE_PEAK + 1;

count = 0;
spikesMap = {}; % [start idx, end idx, mouse id, file name]
spikesTimes = {};
spikesTraces = [];
for row=1:size(twdb,2)
    session = twdb(row);
    index = session.index;
    mouseID = session.mouseID;
    taskType = session.taskType;
    sessionNumber = session.sessionNumber;
    fname = sprintf('idx%d_m%s_%s_s%d.mat', index, mouseID, taskType, sessionNumber);
    fpath = [conf.SPIKES_DIR filesep fname];
    if exist(fpath, 'file') ~= 2
        fprintf('File not found: %s\n', fpath);
        continue;
    end
    
    fprintf('Row: %d/%d, count %d ...\n', row, size(twdb,2), count);
    
    [sessionSpikesTraces, sessionSpikesTimes] = classification.getTraces( ...
        fpath, BUFFER_BEFORE_PEAK, BUFFER_AFTER_PEAK);
    if isempty(sessionSpikesTraces)
        fprintf('Empty trace! file name: %s \n', fname);
        continue;
    end

    spikesTraces = [spikesTraces sessionSpikesTraces];
    spikesTimes = [spikesTimes sessionSpikesTimes];
    startIdx = length(spikesTimes) - length(sessionSpikesTimes) + 1;
    endIdx = length(spikesTimes);
    spikesMap{end + 1} = {startIdx, endIdx, fname};    
        
    count = count + 1;
    if mod(count, BATCH_SIZE) == 0
        grade_batch(spikesTraces, spikesTimes, spikesMap, goldSpikes, peakIdx);
        spikesTraces = [];
        spikesTimes = [];
        spikesMap = {};
        count = 0;
    end
end
grade_batch(spikesTraces, spikesTimes, spikesMap, goldSpikes, peakIdx);

function grade_batch(spikesTraces, spikesTimes, spikesMap, goldSpikes, peakIdx)
conf = config();

[spikesGrades, spikesGroups] = classification.gradeSpikes(...
    spikesTraces, spikesTimes, goldSpikes, peakIdx);

% Output the grades and scores per session
spikesTimesMat = vertcat(spikesTimes{:});
for i=1:length(spikesMap)
    startIdx = spikesMap{i}{1,1};
    endIdx = spikesMap{i}{1,2};
    filename = spikesMap{i}{1,3};
    
    startTimes = {spikesTimesMat{startIdx:endIdx, 1}};
    peakTimes = {spikesTimesMat{startIdx:endIdx, 2}};
    burstTimes = {spikesTimesMat{startIdx:endIdx, 3}};
    grades = num2cell(spikesGrades(startIdx:endIdx));
    groups = num2cell(spikesGroups(startIdx:endIdx));
    
    sessionSpikes = [startTimes' peakTimes' grades' burstTimes' groups'];
    save(sprintf('%s/grades_%s', conf.GRADES_DIR, filename), 'sessionSpikes');
end
end
