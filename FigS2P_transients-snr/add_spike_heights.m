SPIKE_PEAK_IDX = 51;
TIMESTEP = 132.2310;

for itwdb=1:length(twdb)
    fprintf('Running twdb row %d...\n', itwdb);
    
    trialspikes = twdb(itwdb).trialSpikes;
    if isempty(trialspikes)
        continue;
    end
    
    session470 = twdb(itwdb).raw470Session;
    session405 = twdb(itwdb).raw405Session;
    try
        extractedSpikes = process_session(...
            session470(:,1), session470(:,2), session405(:,1), session405(:,2));
    catch
        continue;
    end
    
    heights = nan(height(trialspikes),1);
    for ispike = 1:height(trialspikes)
        starttime = trialspikes(ispike,:).StartTime;
        peaktime = trialspikes(ispike,:).PeakTime;
        spikeTrace = extractedSpikes{starttime == [extractedSpikes{:,1}],7};
        spikeStartIDX = SPIKE_PEAK_IDX - round((peaktime - starttime) / TIMESTEP);
        spikeheight = spikeTrace(SPIKE_PEAK_IDX) - spikeTrace(spikeStartIDX);
        heights(ispike) = spikeheight;
    end
    trialspikes.Heights = heights;
    twdb(itwdb).trialSpikes = trialspikes;
end