function [stdTraces] = get_purple_trace_at_blue_spike_ts(purple_trc, purple_ts, blue_spike_ts)


% reshape to make sure operations are correct
purple_trc = reshape(purple_trc,numel(purple_trc),1);
purple_ts = reshape(purple_ts,numel(purple_ts),1);

% subtract the double exponential fit curve
expFitParams = fit(purple_ts,purple_trc,'exp2');
expFitArray = expFitParams.a * exp(expFitParams.b * purple_ts) + expFitParams.c * exp(expFitParams.d * purple_ts);
fixedTrace = purple_trc - expFitArray;

% create a band-pass filter and filter the trace
order = 3;
fcutlow = 0.10;
fcuthigh = 1;
fs = 1/(0.132);
[b,a] = butter(order, [fcutlow,fcuthigh]/(fs/2),'bandpass');
filtered = filtfilt(b,a,fixedTrace);

% create a Hanning filter to smooth the data
smoothing = 3;
hw = hanning(2*smoothing+1);
filtered = conv(filtered(1:end),hw,'same') / sum(hw);

% smooth the data further using locally weighted smoothing linear regression
filtered = smooth(filtered,'lowess');

mn = mean(filtered);
sd = std(filtered);

stdTraces = cell(length(blue_spike_ts),4);

for ii = 1:length(blue_spike_ts)
    [~,tIdxMax] = max(1./(purple_ts - blue_spike_ts(ii)));

    stdTraces{ii,4} = (filtered(max(tIdxMax-50,1):min(tIdxMax+49,length(filtered)-1))-mn) / sd;
    stdTraces{ii,3} = (fixedTrace(max(tIdxMax-50,1):min(tIdxMax+49,length(filtered)-1))-mean(fixedTrace)) / std(fixedTrace);
    stdTraces{ii,2} = fixedTrace(max(tIdxMax-50,1):min(tIdxMax+49,length(filtered)-1));
    stdTraces{ii,1} = purple_trc(max(tIdxMax-50,1):min(tIdxMax+49,length(filtered)-1));

end

end