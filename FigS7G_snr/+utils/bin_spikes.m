function [all_swn_counts,all_msn_counts] = bin_spikes(swn_spikes,msn_spikes,bin_time)
all_swn_counts = [];
all_msn_counts = [];
for spike_idx = 1: length(swn_spikes)
    [swn_N, swn_edges] = histcounts(cell2mat(swn_spikes(spike_idx)), floor(40/bin_time));
    msn_N = histcounts(cell2mat(msn_spikes(spike_idx)), swn_edges);
    all_swn_counts = [all_swn_counts swn_N/bin_time];
    all_msn_counts = [all_msn_counts msn_N/bin_time];
end
end

