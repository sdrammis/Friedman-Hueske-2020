function [draw, xs] = dynamics(swn_spikes,msn_spikes,bin_time,num_rasters)
draw = 0;
[xs, snrs] = utils.snr_clustering(swn_spikes,msn_spikes,bin_time,num_rasters);

if length(snrs) > 3  
    hold on
    yyaxis right
    ylabel('SNR of SWN Spikes');
    plot(xs, snrs, '--x');
    b = gca; legend(b,'off');
    draw = 1;

    yyaxis left
    [swn_bins,msn_bins] = utils.bin_spikes(swn_spikes,msn_spikes,bin_time);
    [x, y] = utils.y_mean(swn_bins, msn_bins);
    [fitobj, gof] = utils.get_fit(x,y);

    FitHandle=plot(fitobj, x, y, 'o');
    set(FitHandle,'color','b');
    xlabel('SWN Firing Rate in Hz');
    ylabel('Striosomal Firing Rate (Hz)');
    title(sprintf('Bin=%.2f, R^2=%.3f', bin_time, gof.rsquare));
    b = gca; legend(b,'off');


    hold off
end 
end

