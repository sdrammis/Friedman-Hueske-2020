function fluorTrials = get_session_fluorescence_sta(twdb, mouseID, sessionIdx, engagement, whole)
fluorTrials = [];

sessionNumber = twdb(sessionIdx).sessionNumber;
trialData = twdb(sessionIdx).trialData;

raw_470 = twdb(sessionIdx).raw470Session;

S_FREQ = 1/0.132; % frame rate
SEC_TO_CUT = 360; % get rid of this many seconds from beginning
FRAMES_TO_CUT = round(SEC_TO_CUT * S_FREQ) + 1;

trace470 = fillmissing(raw_470(:,2), 'linear');
traceTimes = fillmissing(raw_470(:,1), 'linear');
trace470 = trace470(FRAMES_TO_CUT:end);
traceTimes = traceTimes(FRAMES_TO_CUT:end);
% try
    expFitParams = fit(traceTimes, trace470, 'exp2');
    expFitArray = expFitParams.a * exp(expFitParams.b * traceTimes) ...
        + expFitParams.c * exp(expFitParams.d * traceTimes);
    trace470 = trace470 - expFitArray;
% catch
%     warning(sprintf('Error session %d for mouse %s', sessionNumber, mouseID));
%     return;
% end

order = 3;
fcutlow = 0.10;
fcuthigh = 1;
fs = 1/(0.132);
[b,a] = butter(order, [fcutlow,fcuthigh]/(fs/2),'bandpass');
trace470 = filtfilt(b,a,trace470);

if whole
    for i=1:height(trialData)
        startTime = trialData{i, 'TrialStartTime'};
        endTime = trialData{i, 'ITIEndTime'};
        trialFluor = trace470(and(traceTimes >= startTime, traceTimes <= endTime));
        fluorTrials = [fluorTrials; trialFluor];
    end
else
    if ~isequal(engagement,'all')
        trialData = trialData(trialData.Engagement == engagement,:);
    end
    for i=1:height(trialData)
        
        startTime = trialData{i, 'ToneStartTime'};
        endTime = trialData{i, 'OutcomeStartTime'};
        
        if isempty(startTime) || isempty(endTime)
            fluorTrials = [fluorTrials; nan(1,98)];
            continue;
        end
        
        startTime = startTime - 3000;
        endTime = endTime + 7000;
        trialFluor = trace470(and(traceTimes >= startTime, traceTimes <= endTime));
        
        if isempty(trialFluor) || length(trialFluor) < 98
            fluorTrials = [fluorTrials; nan(1,98)];
            continue;
        end
        
        fluorTrials = [fluorTrials; trialFluor(1:98,:)'];
        
    end
end
end