function [fluorTrials470,fluorTrials405,timeTrials470,timeTrials405] = get_session_fluorescence_sta_edit2QZ(twdb,...
    mouseID, sessionIdx, engagement, whole, period)
fluorTrials470 = {};
fluorTrials405 = {};
timeTrials470 = {};
timeTrials405 = {};
sessionNumber = twdb(sessionIdx).sessionNumber;
trialData = twdb(sessionIdx).trialData;

raw_470 = twdb(sessionIdx).raw470Session;
raw_405 = twdb(sessionIdx).raw405Session;

S_FREQ = 1/0.132; % frame rate
SEC_TO_CUT = 360; % get rid of this many seconds from beginning
FRAMES_TO_CUT = round(SEC_TO_CUT * S_FREQ) + 1;

trace470 = fillmissing(raw_470(:,2), 'linear');
traceTimes470 = fillmissing(raw_470(:,1), 'linear');
trace470 = trace470(FRAMES_TO_CUT:end);
traceTimes470 = traceTimes470(FRAMES_TO_CUT:end);
trace405 = fillmissing(raw_405(:,2), 'linear');
traceTimes405 = fillmissing(raw_405(:,1), 'linear');
trace405 = trace405(FRAMES_TO_CUT:end);
traceTimes405 = traceTimes405(FRAMES_TO_CUT:end);
try
    expFitParams = fit(traceTimes470, trace470, 'exp2');
    expFitArray = expFitParams.a * exp(expFitParams.b * traceTimes470) ...
        + expFitParams.c * exp(expFitParams.d * traceTimes470);
    trace470 = trace470 - expFitArray;
    expFitParams = fit(traceTimes405, trace405, 'exp2');
    expFitArray = expFitParams.a * exp(expFitParams.b * traceTimes405) ...
        + expFitParams.c * exp(expFitParams.d * traceTimes405);
    trace405 = trace405 - expFitArray;
catch
    warning(sprintf('Error session %d for mouse %s', sessionNumber, mouseID));
    return;
end

order = 3;
fcutlow = 0.10;
fcuthigh = 1;
fs = 1/(0.132);
[b,a] = butter(order, [fcutlow,fcuthigh]/(fs/2),'bandpass');
trace470 = filtfilt(b,a,trace470);
trace405 = filtfilt(b,a,trace405);

if whole
    fluorTrials470 = {[]};
    fluorTrials405 = {[]};
    for i=1:height(trialData)
        startTime = trialData{i, 'TrialStartTime'};
        endTime = trialData{i, 'ITIEndTime'};
        trialFluor470 = trace470(and(traceTimes470 >= startTime, traceTimes470 <= endTime));
        fluorTrials470{1} = [fluorTrials470{1}; trialFluor470];
        trialFluor405 = trace405(and(traceTimes405 >= startTime, traceTimes405 <= endTime));
        fluorTrials405{1} = [fluorTrials405{1}; trialFluor405];
    end
else
    if ~isequal(engagement,'all')
        trialData = trialData(trialData.Engagement == engagement,:);
    end
    for i=1:height(trialData)
        if strcmp(period,'tone')
            startTime = trialData{i, 'ToneStartTime'};
            endTime = trialData{i, 'ResponseStartTime'};
        elseif strcmp(period,'response')
            startTime = trialData{i, 'ResponseStartTime'};
            endTime = trialData{i, 'OutcomeStartTime'};
        elseif strcmp(period,'outcome')
            startTime = trialData{i, 'OutcomeStartTime'};
            endTime = trialData{i, 'OutcomeEndTime'};
        elseif strcmp(period,'ITI')
            startTime = trialData{i, 'OutcomeEndTime'};
            endTime = trialData{i, 'ITIEndTime'};
        end
        if isempty(startTime) || isempty(endTime) || (endTime-startTime) <= 0 || ...
                ~sum(traceTimes470<startTime) || ~sum(traceTimes470>endTime) || ...
                ~sum(traceTimes405<startTime) || ~sum(traceTimes405>endTime)
            fluorTrials470{i} = [];
            fluorTrials405{i} = [];
            timeTrials470{i} = [];
            timeTrials405{i} = [];
            continue;
        end
        trialFluor470 = trace470(and(traceTimes470 >= startTime, traceTimes470 <= endTime));
        trialFluor405 = trace470(and(traceTimes405 >= startTime, traceTimes405 <= endTime));
        if isempty(trialFluor470)
            fluorTrials470{i} = [];
            timeTrials470{i} = [];
        else
            fluorTrials470{i} = trialFluor470;
            timeTrials470{i} = (endTime-startTime)/1000;
        end
        if isempty(trialFluor405)
            fluorTrials405{i} = [];
            timeTrials470{i} = [];
        else
            fluorTrials405{i} = trialFluor405;
            timeTrials405{i} = (endTime-startTime)/1000;
        end
    end
end
end