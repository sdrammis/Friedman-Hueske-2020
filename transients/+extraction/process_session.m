function spikes = process_session(times470, trace470, times405, trace405)
% output:
%      write 1 file per animal: animal_%d.mat
%      file contains 1 variable:
%          spike_info: contains 6 columns per identified spike
%            1: start time of spike
%            2: peak time of spike
%            3: if spike is part of a burst, start time of burst
%   NOTE: FOR THE NEXT FEW COLUMNS, 470 TRACE IS TAKEN 50 FRAMES BEFORE START AND 50 FRAMES AFTER PEAK
%         405 TRACE IS TAKEN STRICTLY IN BETWEEN THE ABOVE TIME PERIODS AND
%         CONTAINS 1 LESS FRAME (SEE BELOW FOR ILLUSTRATION)
%    TIME ---->---->---->---->---->---->---->---->---->---->---->---->
%       470: S-50       S-49      X-48 .....    E+49       E+50
%       405:        X          X             X         X
%
%            4: 470 raw trace
%            5: 470 raw trace (after double-exponential subtraction)
%            6: 470 z-score trace (after double-exponential subtraction)
%            7: 470 z-score trace (after double-exponential subtraction, both filtered and smoothed)
%            8: 405 raw trace
%            9: 405 raw trace (after double-exponential subtraction)
%           10: 405 z-score trace (after double-exponential subtraction)
%           11: 405 z-score trace (after double-exponential subtraction, both filtered and smoothed)
%

SFREQ = 1/0.132; % Frame rate.
CUT_SECTION = 240; % Number of seconds to remove from start.
framesToCut = round(CUT_SECTION*SFREQ)+1;
spikes = [];

% Ensure the time data is a column vector.
times470 = reshape(times470, 1, numel(times470));
times405 = reshape(times405, 1, numel(times405));

% Recording must be long enough.
if length(times470) < framesToCut
    return
end

% Interpolate NaN values using linear interpolation.
times470 = fillmissing(times470, 'linear');
trace470 = fillmissing(trace470, 'linear');
times405 = fillmissing(times405, 'linear');
trace405 = fillmissing(trace405, 'linear');

% Remove the beginning of the recording because the day in this period does
% not follow double exp.
times470 = times470(framesToCut:end);
trace470 = trace470(framesToCut:end);
times405 = times405(framesToCut:end);
trace405 = trace405(framesToCut:end);

% Remove step artifacts from the recordings.
trace470 = extraction.remove_steps(trace470, 20, 1.5, 8);
trace405 = extraction.remove_steps(trace405, 20, 1.5, 8);

% Reinterpolate post step removal.
times470 = fillmissing(times470, 'linear');
trace470 = fillmissing(trace470, 'linear');
times405 = fillmissing(times405, 'linear');
trace405 = fillmissing(trace405, 'linear');

% Find spikes in the 470 channel and associated 405 traces
[spikeTimes470, spikeTraces470] = ...
    extraction.get_blue_spike_info(trace470, times470, 1.5);
spikeTraces405 = extraction.get_purple_trace_at_blue_spike_ts(...
    trace405, times405, spikeTimes470(:,2));

% Format output.
spikes = cell(size(spikeTimes470,1), 2);
for iSpike=1:size(spikeTimes470,1)
   spikes{iSpike,1} = spikeTimes470(iSpike,1);
   spikes{iSpike,2} = spikeTimes470(iSpike,2);
end
spikes = [spikes spikeTraces470 spikeTraces405];
end
