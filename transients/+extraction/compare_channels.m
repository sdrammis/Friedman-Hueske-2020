function ratio_matrix = compare_channels(signal_spike_matrix, sig_ts, control_spike_matrix, cont_ts, lower_th)
%Inputs:
%-signal: r x 1 vector representing y values of signal
%-sig_ts: r x 1 vector representing x values of signal
%-control: r x 1 vector representing y values of control
%-cont_ts: r x 1 vector represeneting x values of control
%
%
%each of signal and control are of the form [start_times, peak_times
%Assumes magnitudes are measured in positive standard deviations
%Returns
%- ratios of found spikes: (0, 100], where spike of inf ratio have
%ratio of 100
%- start times of corresponding spikes
%- end times of corresponding spikes


%sig_spikes = extract_spikes(signal, sig_ts, th, 0);
%cont_spikes = extract_spikes(control, cont_ts, th, 0);


%% parameters to fiddle with
max_time_difference = 0.6; %in seconds TODO fiddle with me



%Get indices of times: too much reverse engineerin
[sig_start_times, sig_time_order] = sort(signal_spike_matrix(:,1));
sig_peak_times  = signal_spike_matrix(:,2);
sig_peak_times = sig_peak_times(sig_time_order);
sig_magnitudes = signal_spike_matrix(:,3);
sig_magnitudes = sig_magnitudes(sig_time_order);
all_sig_times = sig_ts;
%disp(sig_peak_times);
[cont_start_times, cont_time_order] = sort(control_spike_matrix(:,1));
cont_peak_times  = control_spike_matrix(:,2);
cont_peak_times = cont_peak_times(cont_time_order);
all_control_times = cont_ts;
cont_magnitudes = control_spike_matrix(:,3);
cont_magnitudes = cont_magnitudes(cont_time_order);


fin_ratio = [];
fin_ratio_peak_times = [];
fin_ratio_start_times = [];
inf_ratio = [];
inf_ratio_peak_times = [];
inf_ratio_start_times = [];

%Find corresponding control spike for each main channel spike
for i = 1:length(sig_start_times)
    found = false;
    for j = 1:length(cont_start_times)
        %if start time within time difference
        if(abs(sig_start_times(i) - cont_start_times(j))< max_time_difference)
            found = true;
            fin_ratio = [fin_ratio sig_magnitudes(i)/cont_magnitudes(j)]; %add ratio of magnitudes
            fin_ratio_peak_times = [fin_ratio_peak_times sig_peak_times(i)]; %add times
            fin_ratio_start_times = [fin_ratio_start_times sig_start_times(i)];
            break;
        end
    end
    if(not(found)) %No corresponding trace in control channel
        fin_ratio = [fin_ratio sig_magnitudes(i)/lower_th]; %add ratio of magnitudes
        fin_ratio_peak_times = [fin_ratio_peak_times sig_peak_times(i)]; %add times
        fin_ratio_start_times = [fin_ratio_start_times sig_start_times(i)];
    end
end



%inf_ratio_place_holder = max(fin_ratio) + 1;

%to_add = ones(1, length(inf_ratio))*inf_ratio_place_holder;

%disp(inf_ratio_place_holder);

% 
% fin_ratio = [fin_ratio inf_ratio];
% fin_ratio_start_times = [fin_ratio_start_times inf_ratio_start_times];
% fin_ratio_peak_times = [fin_ratio_peak_times inf_ratio_peak_times];






%assert(not(cdf_val == 0))

ratio_matrix = [fin_ratio' fin_ratio_start_times' fin_ratio_peak_times'];


end