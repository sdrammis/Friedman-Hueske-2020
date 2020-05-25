function [xs, snrs] = snr_clustering(swn_spikes,msn_spikes,bin_time,num_rasters)

[swn_bin_frs, swn_bin_spikes, msn_bin_spikes, bin_edges, trial_num] = ...
    rasters.get_bins_spikes(swn_spikes,msn_spikes,bin_time);
max_swn_fr = max(swn_bin_frs);
raster_edges = linspace(0, max_swn_fr, num_rasters+1);
xs = [];
snrs = [];
for jj=1:length(raster_edges)-1
    low = raster_edges(jj);
    high = raster_edges(jj+1);
    
    if jj == length(raster_edges)-1
        idxs = swn_bin_frs >= low & swn_bin_frs <= high;
    else
        idxs = swn_bin_frs >= low & swn_bin_frs < high;
    end
    raster_dat_swn = swn_bin_spikes(idxs);
    raster_dat_msn = msn_bin_spikes(idxs);
    raster_dat_bin_edges = bin_edges(idxs,:);
    raster_dat_trial_nums = trial_num(idxs);
    [distance_dist,bins,distances] = utils.hist_distances(raster_dat_msn, raster_dat_trial_nums, raster_dat_bin_edges, 1);
    distance_dist = distance_dist(distance_dist > 0);
    if ~isempty(distance_dist)
        if length(distance_dist) == 1
            snr = 0;
        else
%             [muhat,~] = expfit(distances);
%             snr = 1/muhat;
            snr = 1/-sum(distance_dist.*log2(distance_dist));
        end
        xs = [xs (low+high)/2];
        snrs = [snrs snr];
    end
end
end