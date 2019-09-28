function betas = spikesLinearRegression(traces, spikeTimes, peakIdx)
% Compute a beta for linear regression comparing the 470 trace to the 405
% trace.
%
% traces: traces from getTraces for which you would like the beta
% spikeTimes: times that correspond with the traces from getTraces
% peakIdx: idx of where the peak is in the trace
%
% returns an array of betas corresponding to the traces

betas = [];

for i=1:size(traces, 2)
    startTime = spikeTimes{i}{1};
    peakTime = spikeTimes{i}{2};
    startIdx = max(1, ceil(peakIdx - ((peakTime - startTime) / (.066 * 2))));
    
    trace470 = traces{i}.Trace470Raw(startIdx:peakIdx);
    trace405 = traces{i}.Trace405Raw(startIdx:peakIdx);

    X = [];
    Y = [];
    
    % filter out (0, 0)
    for ii=1:length(trace470)
       val470 = trace470(ii);
       val405 = trace405(ii);
       if val470 == 0 && val405 == 0
           continue;
       end
       
       X = [X; val470];
       Y = [Y; val405];
    end

    b = X \ Y;
    betas = [betas b];
end
end

