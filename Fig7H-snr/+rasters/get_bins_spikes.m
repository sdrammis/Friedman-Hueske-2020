function [swn_bin_frs, swn_bin_spikes, msn_bin_spikes, bin_edges, trial_num] = ...
    get_bins_spikes(swn_spikes,msn_spikes,bin_time)
trial_num = [];
swn_bin_frs = [];
bin_edges = [];
swn_bin_spikes = {};
msn_bin_spikes = {};
for ii = 1:length(swn_spikes)    
    % Get strio counts
    trial_spikes_swn = cell2mat(swn_spikes(ii));
    trial_spikes_msn = cell2mat(msn_spikes(ii));
    
    [swn_n, swn_edges] = histcounts(trial_spikes_swn, floor(40/bin_time));
    trial_spikes_bins_swn = discretize(trial_spikes_swn, swn_edges);
    trial_spikes_bins_msn = discretize(trial_spikes_msn, swn_edges);
    swn_bin_frs = [swn_bin_frs swn_n/bin_time];
    
    for jj=1:length(swn_n)
        swn_fr = swn_n(jj);
        trial_num = [trial_num ii];
        bin_start_edge = swn_edges(jj);
        bin_end_edge = swn_edges(jj+1);
        swn_idxs = trial_spikes_swn >= bin_start_edge & trial_spikes_swn <= bin_end_edge;
        msn_idxs = trial_spikes_msn >= bin_start_edge & trial_spikes_msn <= bin_end_edge;
        bin_edges = [bin_edges; bin_start_edge bin_end_edge];
        
        swn_bin_spikes{end+1} = trial_spikes_swn(swn_idxs);
        msn_bin_spikes{end+1} = trial_spikes_msn(msn_idxs);
    end
end
end

