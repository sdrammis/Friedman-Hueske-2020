function areas = spikesArea(traces, spikeTimes, peakIdx)
% Computes the difference between the area under the peak in the 470 and
% 405 channels
%
% traces: trace results from getTraces
% spikeTimes: times results from getTraces
% peakIdx: idx in the trace where the peak is
%
% returns an array of areas corresponding to the traces

areas = nan(1,size(traces,2));
 
for i=1:size(traces,2)
    startTime = spikeTimes{i}{1};
    peakTime = spikeTimes{i}{2};
    startIdx = max(1, ceil(peakIdx - ((peakTime - startTime) / (.066 * 2))));
     
    trace470Sub = traces{i}.Trace470Raw(startIdx:peakIdx);
    trace405Sub = traces{i}.Trace405Raw(startIdx:peakIdx);
    trace470 = traces{i}.Trace470Raw;
    trace405 = traces{i}.Trace405Raw;
     
    mag = trace405Sub \ trace470Sub;
    a = sum(trace470(peakIdx-2:peakIdx+2)) - sum(mag * trace405(peakIdx-2:peakIdx+2));
    areas(i) = a;
end
end