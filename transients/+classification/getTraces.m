function [sessionSpikesTraces, sessionSpikesTimes] = getTraces(fpath, bufferBeforePeak, bufferAfterPeak)
% Given session information, returns the traces and spike times from the
% extracted spikes traces
% 
% mouseID: id of mouse to get extracted spikes
% sessionNumber: session for mouse to get extracted spikes
% extractedSpikesPath: path to the extracted spikes from photometry data
% bufferBeforePeak: how many timestamps to include trace of before the peak
% bufferAfterPeak: number of timestamps to include trace of after the peak
%
% returns [traces, times]
%   traces -- table: { smoothed 470 trace, smoothed 405 trace,
%                      raw 470 trace, raw 405 trace}
%   times -- { start time, peak time, burst time }

sessionSpikesTraces = {};
sessionSpikesTimes = {};

PEAK_OFFSET_FROM_END = 50;

dat = load(fpath);
sessionSpikesInfo = dat.spikes;
if isempty(sessionSpikesInfo)
    return;
end
startTimes = sessionSpikesInfo(:, 1);
peakTimes = sessionSpikesInfo(:, 2);
burstTimes = sessionSpikesInfo(:, 3);
tracesRaw470 = sessionSpikesInfo(:, 5);
tracesRaw405 = sessionSpikesInfo(:, 9);
tracesZScore470 = sessionSpikesInfo(:, 7);
tracesZScore405 = sessionSpikesInfo(:, 11);

for i=1:size(tracesZScore470,1)
    startTime = startTimes{i};
    peakTime = peakTimes{i};
    burstTime = burstTimes{i};
    traceZScore470 = tracesZScore470{i};
    traceZScore405 = tracesZScore405{i};
    traceRaw470 = tracesRaw470{i};
    traceRaw405 = tracesRaw405{i};

    if size(traceZScore405,1) == size(traceZScore470,1)
        % TODO fix edge case from extracted-spikes
        continue;
    end

    peakIdx = size(traceZScore470,1) - PEAK_OFFSET_FROM_END;
    startIdx = peakIdx - bufferBeforePeak;
    endIdx = peakIdx + bufferAfterPeak;
    
    if startIdx <= 0 || endIdx > size(traceZScore470,1)
       continue; 
    end
    
    traceZScore405Interp = interpolate405(traceZScore405);
    subTraceZScore470 = traceZScore470(startIdx:endIdx);
    subTraceZScore405 = traceZScore405Interp(startIdx:endIdx);

    traceRaw405Interp = interpolate405(traceRaw405);
    subTraceRaw470 = traceRaw470(startIdx:endIdx);
    subTraceRaw405 = traceRaw405Interp(startIdx:endIdx);

    sessionSpikesTraces{end + 1} = table(subTraceZScore470, subTraceZScore405, subTraceRaw470, subTraceRaw405, ...
        'VariableNames', {'Trace470', 'Trace405', 'Trace470Raw', 'Trace405Raw'});
    sessionSpikesTimes{end + 1} = {startTime peakTime burstTime};
end
end

function new405 = interpolate405(trace405)
% Given a 405 trace interpolates and returns the inbetween values
% This is needed to match up with the exact 470 times
%
% returns a new 405 trace array 1 index shorter than the original

new405 = nan(size(trace405, 1) + 1, 1);
arr = [trace405(1); trace405; trace405(end)];
for i=2:size(arr,1)
    new405(i-1) = (arr(i-1) + arr(i)) / 2;
end
end
