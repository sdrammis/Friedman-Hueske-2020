function [spikes,times,spikeHeights,spikeLengths] = spikesByPeriod(session,period)

trialData = session.trialData;
trialSpikes = session.trialSpikes;
noHeights = 0;
if isequal(period,'all')
    if ~isempty(trialSpikes)
        spikes = histcounts(trialSpikes.trialIDX,1:(height(trialData)+1))';
        session470 = session.raw470Session;
        session405 = session.raw405Session;
        try
            extractedSpikes = process_session(...
                session470(:,1), session470(:,2), session405(:,1), session405(:,2));
        catch
            noHeights = 1;
        end
        trials_withSpikes = unique(trialSpikes.trialIDX);
        spikeHeights = nan(height(trialData),1);
        spikeLengths = nan(height(trialData),1);
        for t = trials_withSpikes'
            spikesInTrial = trialSpikes(trialSpikes.trialIDX == t,:);
            if ~noHeights
                trialHeights = [];
                for s = 1:height(spikesInTrial)
                    spike = spikesInTrial(s,:);
                    spikeTrace = extractedSpikes{spike.StartTime == [extractedSpikes{:,1}],7};
                    trialHeights = [trialHeights spikeTrace(51)];
                end
                spikeHeights(t) = nanmean(trialHeights);
            end
            spikeLengths(t) = nanmean((spikesInTrial.PeakTime - spikesInTrial.StartTime)/1000);
        end
    else
        spikes =  nan(height(trialData),1);
        spikeHeights = nan(height(trialData),1);
        spikeLengths = nan(height(trialData),1);
    end
    times = (trialData.ITIEndTime - trialData.TrialStartTime)/1000;
else
    if isequal(period,'Response')
        periodStartTime = trialData.ResponseStartTime;
        periodEndTime = trialData.OutcomeStartTime;
    elseif isequal(period,'Tone')
        periodStartTime = trialData.ToneStartTime;
        periodEndTime = trialData.ResponseStartTime;
    elseif isequal(period,'Tone + Response')
        periodStartTime = trialData.ToneStartTime;
        periodEndTime = trialData.OutcomeStartTime;
    end

    if ~isempty(trialSpikes)

        session470 = session.raw470Session;
        session405 = session.raw405Session;
        try
            extractedSpikes = process_session(...
                session470(:,1), session470(:,2), session405(:,1), session405(:,2));
        catch
            noHeights = 1;
        end
        
        spikes = zeros(height(trialData),1);
        trials_withSpikes = unique(trialSpikes.trialIDX);
        spikeHeights = nan(height(trialData),1);
        spikeLengths = nan(height(trialData),1);
        for t = trials_withSpikes'
            spikesInTrial = find(trialSpikes.trialIDX == t);
            spikeStartTimes = trialSpikes.StartTime(trialSpikes.trialIDX == t);
            spikesInPeriod = and(spikeStartTimes > periodStartTime(t),spikeStartTimes < periodEndTime(t));
            spikes(t) = sum(spikesInPeriod);
            if sum(spikesInPeriod) < 1
                continue
            end
            if sum(spikesInPeriod) > 1
                continue
            end
            spike = trialSpikes(spikesInTrial(spikesInPeriod),:);
            startTime = spike.StartTime;
            peakTime = spike.PeakTime;
            if ~noHeights
                spikeTrace = extractedSpikes{startTime == [extractedSpikes{:,1}],7};
                spikeHeights(t) = spikeTrace(51);
            end
            spikeLengths(t) = (peakTime-startTime)/1000;
        end
    else
        spikes =  nan(height(trialData),1);
        spikeHeights = nan(height(trialData),1);
        spikeLengths = nan(height(trialData),1);
    end
    
    times = (periodEndTime - periodStartTime)/1000;
end