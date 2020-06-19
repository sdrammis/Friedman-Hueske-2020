NUM_RASTERS = 4;
NUM_RASTER_BINS = 20;

swn_idx = 13656;
msn_idx = 13783;
swn_spikes = twdb_control(swn_idx).trial_spikes;
msn_spikes = twdb_control(msn_idx).trial_spikes;
bin_time = 1.0;

f = figure;
subplot(2,NUM_RASTERS,1:NUM_RASTERS);
[draw,xs] = plot.dynamics(swn_spikes,msn_spikes,bin_time,NUM_RASTER_BINS);
xlim([0 8]);
[swn_bin_frs, swn_bin_spikes, msn_bin_spikes, bin_edges, trial_num] = ...
    rasters.get_bins_spikes(swn_spikes,msn_spikes,bin_time);
max_swn_fr = max(swn_bin_frs);
raster_edges = linspace(0, max_swn_fr, NUM_RASTER_BINS+1);
d = length(xs);
for jj=1:NUM_RASTERS
    idx_ = min((jj-1) * round(length(xs) / NUM_RASTERS) + 1, length(xs));
    idx = sum(raster_edges < xs(idx_));
    low = raster_edges(idx);
    high = raster_edges(idx+1);

    if jj == NUM_RASTERS
        idxs = swn_bin_frs >= low & swn_bin_frs <= high;
    else
        idxs = swn_bin_frs >= low & swn_bin_frs < high;
    end
    raster_dat_msn = msn_bin_spikes(idxs);
    raster_dat_bin_edges = bin_edges(idxs,:);
    raster_dat_trial_nums = trial_num(idxs);

    subplot(2,NUM_RASTERS,NUM_RASTERS+jj);
    plot.raster(raster_dat_msn, raster_dat_bin_edges, raster_dat_trial_nums);
    title(sprintf('Bin edges = [%.2f, %.2f]', low, high));
    xlim([-20 20]);

end
sgtitle(sprintf('swn idx=%d, msn idx=%d, msn striosomality=%d', swn_idx, msn_idx, twdb_control(msn_idx).striosomality2_type));

%% This is for the snr stats with chisquare test
f2 = figure;
input = [1/18 17/18; 2/4 2/4];
X = [1 2];
N = [18 4];
b = bar(input, 'stacked');
[h,p, chi2stat,df] = prop_test(X , N, false);
suptitle(sprintf('chi2=%.4f', p));
set(gca, 'xTickLabel', {'Striosomal', 'Matrix'});
ylabel('SPN Response Type (%)');
legend('SNR Decay', 'Enhanced SNR');
