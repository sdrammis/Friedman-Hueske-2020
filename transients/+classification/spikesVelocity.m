function vels = spikesVelocity(traces, peakIdx)
% Computs the difference of the velocities before the peak
% of the 470 and 405 channels
%
% traces: results of getTraces
% peakIdx: idx where the peak is in the trace
%
% returns an array of velocities

vels = []; 
 
for i=1:size(traces,2)
    trace470 = traces{i}.Trace470;
    trace405 = traces{i}.Trace405;
    vel470 = (trace470(peakIdx) - trace470(peakIdx-2)) / 3;
    vel405 = (trace405(peakIdx) - trace405(peakIdx-2)) / 3;
    vels = [vels; vel470 - vel405];
end
end