function [distance_dist,bins,distances] = hist_distances(spikes, trial_num, bin_edges, threshold)
distance_dist = [];
bins = [];
distances = [];
for trial = unique(trial_num)
    trial_spikes = spikes(trial_num==trial);
    trial_spikes = sort(cell2mat(trial_spikes(:))); % spikes in ascending order
    if length(trial_spikes) < threshold
        continue;
    end
    for idx = 2:length(trial_spikes)
        distances = [distances (trial_spikes(idx) - trial_spikes(idx-1))];
    end
end
if length(distances) >= 1
    [distance_dist, bins] = histcounts(distances,10,'Normalization', 'probability');
end

