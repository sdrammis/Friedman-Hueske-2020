function twdb = addSpikes_HD_DB(twdb,spikesFile)

files = strsplit(spikesFile,filesep);

behFile = files{end}(8:end);
sessionIdx = twdb_lookup(twdb,'index','key','filename',behFile);
sessionIdx = sessionIdx{1};
load(spikesFile)

trials = twdb(sessionIdx).trials;
spike_times = [spike_info{:,1}]*1000;
total_spikes = [];

trialSpikes = cell(length(trials),1);
for trial_idx = 1:length(trials)
    trial_start = trials{trial_idx}(1,1);
    trial_end = trials{trial_idx}(end,1);
    plot([trial_start trial_start],[-0.1,0],'r')
    plot([trial_end trial_end],[0,0.1],'k')
    
    
    trial_spike_idx = find(spike_times(spike_times<=trial_end)>=trial_start);
    total_spikes = [total_spikes; trial_spike_idx'];
    if ~isempty(trial_spike_idx)
        spikesInTrial = cell(length(trial_spike_idx),5);
        spikesInTrial(:,1:4) = spike_info(trial_spike_idx,1:4);
        
        % Bursts
        burst_idx = find(~cellfun(@isempty,spikesInTrial(:,4)));
        if ~isempty(burst_idx)
            trial_bursts_times = unique([spikesInTrial{burst_idx,4}]);
            for idx = burst_idx'
                burst_time = spikesInTrial{idx,4};
                burstN = find(trial_bursts_times==burst_time);
                spikesInTrial{idx,5} = burstN;
            end
        end
        
        trialSpikes{trial_idx} = cell2table(spikesInTrial,...
        'VariableNames',{'StartTime','PeakTime','Grade','BurstStartTime','BurstNumber'});
    end
    
end
twdb(sessionIdx).trialSpikes = trialSpikes;
twdb(sessionIdx).sessionGrade = tr_grade;
