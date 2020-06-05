START_POINT = [1 0 5 1];
T = {};

swn_index = [1046,5453];
msn_index = [999,5426];
bin_time = [1,1];

for i = 1:length(swn_index)
    swn = twdb_control(swn_index(i));
    msn = twdb_control(msn_index(i));
    swn_spikes = swn.trial_spikes;
    msn_spikes = msn.trial_spikes;

    all_swn_counts = [];
    all_msn_counts = [];
    for spike_idx = 1: length(swn_spikes)
        [swn_N, swn_edges] = histcounts(cell2mat(swn_spikes(spike_idx)), floor(40/bin_time(i)));
        msn_N = histcounts(cell2mat(msn_spikes(spike_idx)), swn_edges);
        all_swn_counts = [all_swn_counts swn_N/bin_time(i)];
        all_msn_counts = [all_msn_counts msn_N/bin_time(i)];
    end

    [xmean, ynew] = y_mean(all_swn_counts, all_msn_counts);
    fitType = fittype('a+(b-a)/(1+exp(c-d*x))', 'independent', 'x', 'dependent', 'y');
    opts = fitoptions( 'Method', 'NonlinearLeastSquares');
    opts.StartPoint = START_POINT;
    opts.Display = 'Off';
    [fitobject,gof] = fit(xmean,ynew,fitType,opts);

    [begin_x, end_x, slope] = pair_slope_analysis(fitobject, xmean, 100, -0.01);

    f = figure;
    plot(fitobject, xmean, ynew, 'o');
    hold on
    plot([begin_x, end_x], [fitobject(begin_x), fitobject(end_x)],'-x');
    xlabel('SWN Firing Rate in Hz');
    ylabel('MSN Firing Rate in Hz');
    msn_type = 'strio';
    title_ = sprintf('swn=%d %s=%d Bin=%.2f, R^2=%.3f', swn_index(i), msn_type, msn_index(i), bin_time(i), gof.rsquare);
    title(title_);
    b = gca; legend(b,'off');
end
