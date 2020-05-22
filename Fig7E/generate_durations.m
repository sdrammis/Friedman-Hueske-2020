FILE_PTHs = ["./selected_matrix_pairs.csv", "./selected_strio_pairs.csv"];
SAVE_PTHs = ["./matrix_duration.mat","./strio_duration.mat"];
START_POINT = [1 0 5 1];
for itr = 1:size(FILE_PTHs,2)
    FILE_PTH = FILE_PTHs(itr);
    SAVE_PTH = SAVE_PTHs(itr);
    T = {};
    M = readmatrix(FILE_PTH);
    for iM = 1:size(M,1)
        row = M(iM,:);
        swn_index = row(1);
        msn_index = row(2);
        bin_time = row(3);
        rsq = row(4);

        swn = twdb_control(swn_index);
        msn = twdb_control(msn_index);
        swn_spikes = swn.trial_spikes;
        msn_spikes = msn.trial_spikes;

        all_swn_counts = [];
        all_msn_counts = [];
        for spike_idx = 1: length(swn_spikes)
            [swn_N, swn_edges] = histcounts(cell2mat(swn_spikes(spike_idx)), floor(40/bin_time));
            msn_N = histcounts(cell2mat(msn_spikes(spike_idx)), swn_edges);
            all_swn_counts = [all_swn_counts swn_N/bin_time];
            all_msn_counts = [all_msn_counts msn_N/bin_time];
        end

        [xmean, ynew] = y_mean(all_swn_counts, all_msn_counts);
        fitType = fittype('a+(b-a)/(1+exp(c-d*x))', 'independent', 'x', 'dependent', 'y');
        opts = fitoptions( 'Method', 'NonlinearLeastSquares');
        opts.StartPoint = START_POINT;
        opts.Display = 'Off';
        [fitobject,gof] = fit(xmean,ynew,fitType,opts);
        if abs(gof.rsquare - rsq) > .05
            continue;
        end

        [begin_x, end_x, slope] = pair_slope_analysis(fitobject, xmean, 100, -0.01);

        dat_x = {xmean};
        dat_y = {ynew};
        fitobj = {fitobject};
        if isempty(T)
            T = table(swn_index, msn_index, bin_time, fitobj, dat_x, dat_y);
        else
            T = [T; {swn_index, msn_index, bin_time, fitobj, dat_x, dat_y}];
        end
    end

    NUM_SAMPLES = 100;
    flat_thre = -0.01;
    begin_xs = [];
    end_xs = [];
    slopes = [];
    for iT = 1:size(T,1)
        row = T(iT,:);
        dat_x = row.dat_x{1};
        dat_y = row.dat_y{1};
        fitobj = row.fitobj{1};
        xmin = min(dat_x);
        xmax = max(dat_x);
        x = linspace(xmin, xmax, NUM_SAMPLES);

        diffs = differentiate(fitobj,x);
        begin_x = 1;
        end_x = NUM_SAMPLES;
        ix = 1;
        while ix < NUM_SAMPLES && diffs(ix) >= flat_thre
            ix = ix + 1;
        end
        begin_x = x(ix);
        begin_xs = [begin_xs begin_x];
        while ix <= NUM_SAMPLES && diffs(ix) < flat_thre 
            ix = ix + 1;
        end
        end_x = x(ix - 1);
        end_xs = [end_xs end_x];
        slope = (fitobj(end_x) - fitobj(begin_x)) / (end_x - begin_x);
        slopes = [slopes slope];
    end
    duration = end_xs - begin_xs;
    save(SAVE_PTH, 'duration');
end