function [spikeTimeMatrix, otherSpikeInfoStruct] = extract_spikes(trc, ts, stdThresh, lowStdThresh, makeFigures,spkSvPath)
% trc - photometry trace
% ts - timestamps associated with the trace
% stdThresh - upper threshold for finding spikes (all spikes or bursts must
%   go above this number of standard deviations). default is 1.5.
% makeFigures - whether to make figures for debugging. default is false.
%
% outputs:
%   spikeTimeMatrix - contains info about each spike found from the trace:
%       column 1 = start time, column 2 = peak time, column 3 = magnitude
%   otherSpikeInfoStruct - contains other info about each spike, such as
%       the waveform
switch nargin
    case 2
        stdThresh = 1.5;
        lowStdThresh = 0.5;
        makeFigures = false;
    case 3
        lowStdThresh = 0.5;
        makeFigures = false;
    case 4
        makeFigures = false;
end

% reshape to make sure operations are correct
trc = reshape(trc,numel(trc),1);
ts = reshape(ts,numel(ts),1);

% subtract the double exponential fit curve
FUNCS = {'poly1', 'poly2', 'exp1', 'exp2'};
func = '';
fitparams = [];
rsquare = 0;
for iFuncs=1:length(FUNCS)
    try
        [fitobject, gof] = fit(ts, trc, FUNCS{iFuncs});
        if gof.rsquare > rsquare
           fitparams = fitobject;
           func = FUNCS{iFuncs};
           rsquare = gof.rsquare;
        end
    catch
        continue;
    end
end
switch func
    case 'poly1'
        fitArray = fitparams.a * ts + fitparams.b;
    case 'poly2'
        fitArray = fitparams.p1 * ts.^2 + fitparams.p2 * ts + fitparams.p3;
    case 'exp1'
        fitArray = fitparams.a * exp(fitparams.b * ts);
    case 'exp2'
        fitArray = fitparams.a * exp(fitparams.b * ts) + fitparams.c * exp(fitparams.d * ts);    
end
fixedTrace = trc - fitArray;

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

% keep some lists of spike information
possible_events = [];
possible_peaks = [];
event_types = [];

% set the thresholds for the spike
mn = mean(filtered);
sd = std(filtered);
thresh = mn + stdThresh*sd;
lowerThresh = mn - lowStdThresh*sd;
MIN_SPIKE_TIME = 0.5 * 10^3;
MAX_SPIKE_TIME = 5 * 10^3;

% find all potential event times for the cell
potential_times = [];
all_maxes = dg_findFlattops(filtered);
% if an event surpasses the upper threshold, it is a candidate
for jj = 1:length(all_maxes)
    if filtered(all_maxes(jj)) > thresh
        potential_times = [potential_times all_maxes(jj)];
    end
end

% plotting utility to show smoothed and raw traces
if makeFigures && 0
    f2 = figure();
    subplot(2,1,1)
    plot(ts,trc);
    hold on;
    plot(ts,fitArray);
    title('Raw trace');
    xlabel('Time (s)');
    ylabel('Trace (arbs)');
    subplot(2,1,2)
    plot(ts,filtered);
    hold on;
    plot(ts,ones(1,length(filtered))*(thresh));
    plot(ts,ones(1,length(filtered))*(lowerThresh));
    title('Filtered trace');
    xlabel('Time (s)');
    ylabel('Trace (arbs)');
end


% for each event that crosses the upper threshold, evaluate it
for jj = length(potential_times):-1:1
    
    % timestamps of interest when looking at an event
    fst = max(potential_times(jj)-120, 1);
    lst = min(potential_times(jj)+119, length(filtered));
    
    % index those to get the trace and timestamps of a small region
    % surrounding an event
    subtrace = filtered(fst:lst);
    subts = ts(fst:lst);
    
    % find all the local maxima
    [X,~,~] = dg_findFlattops(subtrace);
    % find all the local minima
    [Y,~,~] = dg_findFlattops(-subtrace);
    % find all points of greatest acceleration
    accel = diff(diff(subtrace));
    [ZZ,~,~] = dg_findFlattops(accel);
    
    % index of the event time in the small region
    underIdx = potential_times(jj)-fst;
    % find the first local maximum after the event time
    [~,xIdx] = max(1./(X - underIdx));
    % find the first local minumum before the spike time
    [~,yIdx] = max(1./(underIdx - Y));
    
    maxIdx = X(xIdx);
    minIdx = Y(yIdx);
    if minIdx>maxIdx
        continue;
    end
    zzIdxs = ZZ(ZZ>=minIdx-2 & ZZ <= maxIdx);
    [~,zzsubIdx] = max(accel(zzIdxs));
    stIdx = zzIdxs(zzsubIdx);
    looksLikeBurst = false;
    looksLikeSingleTrace = false;
    
    % the spike in question lasts for more than the minimum spike time and
    % lasts for less than the maximum spike time
    timingIsCorrect = subts(maxIdx) - subts(minIdx) < MAX_SPIKE_TIME && subts(maxIdx) - subts(minIdx) > MIN_SPIKE_TIME;
    if timingIsCorrect
        looksLikeSingleTrace = (subtrace(maxIdx) > thresh && subtrace(minIdx) < lowerThresh);
        looksLikeBurst = false;
        if looksLikeSingleTrace
            if subts(maxIdx) - subts(stIdx) > MIN_SPIKE_TIME
                possible_events = [possible_events subts(stIdx)];
                possible_peaks = [possible_peaks subts(maxIdx)];
                event_types = [event_types 1];
            end
        elseif subtrace(maxIdx) - subtrace(minIdx) > sd% check to see if the spike could be part of a burst; the maximum number of spikes we say is in a burst is 6
            goBack = 0;
            if (subtrace(maxIdx) > thresh && subtrace(minIdx) > lowerThresh)
                for iBurst = 1:5
                    if xIdx > iBurst && yIdx > iBurst
                        prevMxI = X(xIdx-iBurst);
                        prevMnI = Y(yIdx-iBurst);
                        isSpikeContinuation = (subts(prevMxI) - subts(prevMnI) < MAX_SPIKE_TIME && subts(prevMxI) - subts(prevMnI) > MIN_SPIKE_TIME) && (subtrace(prevMxI) - subtrace(prevMnI) > sd);
                        if isSpikeContinuation
                            if subtrace(prevMnI) < lowerThresh
                                looksLikeBurst = true;
                                goBack = iBurst;
                            end
                        else
                            break
                        end
                    end
                    if looksLikeBurst
                        break
                    end
                end
            end
            % bookkeeping for determining start and peak times of bursts
            if looksLikeBurst
                % the non-first spikes in a burst start at the local
                % minimum point before a spike
                for kk = 0:goBack-1
                    possible_events = [possible_events subts(Y(yIdx - kk))];
                    possible_peaks = [possible_peaks subts(X(xIdx - kk))];
                    event_types = [event_types 0];
                end
                % the first spike in a burst starts at the max acceleration
                % point, like a single spike
                zzIdxs2 = ZZ(ZZ>=Y(yIdx - goBack)-2 & ZZ <= X(xIdx - goBack));
                if ~isempty(zzIdxs2)
                    [~,zzsubIdx] = max(accel(zzIdxs2));
                    possible_events = [possible_events subts(zzIdxs2(zzsubIdx))];
                    possible_peaks = [possible_peaks subts(X(xIdx - goBack))];
                    event_types = [event_types 0];
                end
            end
        end
    end % end of conditions to check trace similarity
    
    % plotting debugger for individual spikes - shows both raw and filtered
    if makeFigures && (looksLikeBurst||looksLikeSingleTrace) && 0
        f = figure();
        subplot(2,1,1);
        plot(subts,subtrace);
        hold on;
        plot(subts,ones(1,length(subtrace))*(thresh));
        plot(subts,ones(1,length(subtrace))*(lowerThresh));
        plot(subts(X),subtrace(X),'o');
        plot(subts(Y),subtrace(Y),'+');
        plot(subts(ZZ),subtrace(ZZ),'s');
        
        plot(subts(stIdx),subtrace(stIdx),'^');
        plot(subts(maxIdx),subtrace(maxIdx),'^');
        plot(subts(minIdx),subtrace(minIdx),'^');
        
        title(sprintf('Trace'));
        xlabel('Time (s)');
        subplot(2,1,2);
        sorigtrace = fixedTrace(fst:lst);
        plot(subts,sorigtrace);
        hold on;
        plot(subts(X),sorigtrace(X),'o');
        plot(subts(Y),sorigtrace(Y),'+');
        plot(subts(ZZ),sorigtrace(ZZ),'s');
        
        plot(subts(stIdx),sorigtrace(stIdx),'^');
        plot(subts(maxIdx),sorigtrace(maxIdx),'^');
        plot(subts(minIdx),sorigtrace(minIdx),'^');
%         close(f);
    end
end % end of for each potential event loop

[possible_events_un,~,~] = unique(possible_events);
possible_peaks_un = unique(possible_peaks);

if length(possible_events_un) ~= length(possible_peaks_un)
    aa = 1;
    while aa <= length(possible_events_un)
        if possible_events_un(aa) > possible_peaks_un(aa)
            possible_peaks_un(aa) = [];
            continue;
        elseif possible_peaks_un(aa) - possible_events_un(aa) > MAX_SPIKE_TIME
            possible_events_un(aa) = [];
            continue;
        else
            aa = aa+1;
        end
    end
end

[~,idxsEvents] = intersect(ts, possible_events_un);
[~,idxsPeaks] = intersect(ts, possible_peaks_un);

if makeFigures
    f3 = figure();
    subplot(2,1,1)
    plot(ts,trc);
    hold on;
    plot(ts,fitArray);
    plot(possible_peaks_un,trc(idxsPeaks),'^');
    plot(possible_events_un,trc(idxsEvents),'^');
    title('Raw trace');
    xlabel('Time (s)');
    ylabel('Trace (arbs)');
    subplot(2,1,2)
    plot(ts,filtered);
    hold on;
    plot(ts,ones(1,length(filtered))*(thresh));
    plot(ts,ones(1,length(filtered))*(lowerThresh));
    plot(possible_peaks_un,filtered(idxsPeaks),'^');
    plot(possible_events_un,filtered(idxsEvents),'^');
    title('Filtered trace');
    xlabel('Time (s)');
    ylabel('Trace (arbs)');
%     savefig(f3,spkSvPath);
%     close(f3);
end



if length(idxsEvents)~=length(idxsPeaks)
    warning('There is some bug in finding events.');
end

spikeTimeMatrix = [possible_events_un', possible_peaks_un', (filtered(idxsPeaks) - filtered(idxsEvents))/sd];
otherSpikeInfoStruct = cell(size(spikeTimeMatrix,1),5);
event_types_un = zeros(size(spikeTimeMatrix,1),1);


% see if spike is good on its own
for ii = 1:length(event_types_un)
    event_types_un(ii) = (filtered(idxsPeaks(ii))>thresh && filtered(idxsEvents(ii)-1)<lowerThresh);
    otherSpikeInfoStruct{ii,5} = (filtered(max(idxsPeaks(ii)-50,1):min(idxsPeaks(ii)+50,length(filtered)))-mn) / sd;
    otherSpikeInfoStruct{ii,4} = (fixedTrace(max(idxsPeaks(ii)-50,1):min(idxsPeaks(ii)+50,length(filtered)))-mean(fixedTrace)) / std(fixedTrace);
    otherSpikeInfoStruct{ii,3} = fixedTrace(max(idxsPeaks(ii)-50,1):min(idxsPeaks(ii)+50,length(filtered)));
    otherSpikeInfoStruct{ii,2} = trc(max(idxsPeaks(ii)-50,1):min(idxsPeaks(ii)+50,length(filtered)));
end

% get correct burst information
lastBurstIdx = 1;
for ii = 1:length(event_types_un)-1
    if event_types_un(ii+1) == 0
        if event_types_un(ii) == 1
            lastBurstIdx = ii;
        end

        if possible_peaks_un(ii+1) - possible_peaks_un(ii) < MAX_SPIKE_TIME
            otherSpikeInfoStruct{ii,1} = possible_events_un(lastBurstIdx);
            otherSpikeInfoStruct{ii+1,1} = possible_events_un(lastBurstIdx);
        else
            lastBurstIdx = ii+1;
        end
    end
end

otherSpikeInfoStruct = otherSpikeInfoStruct(spikeTimeMatrix(:,3) ~= 0,:);
spikeTimeMatrix = spikeTimeMatrix(spikeTimeMatrix(:,3) ~= 0,:);

end