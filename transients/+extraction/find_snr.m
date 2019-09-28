function [SNR_matrix, SNR_trace, blueSpikeInfo] = find_snr(blue, blueT, purple, purpleT, gaussSvPath, spkSvPath)
    %Return the SNR matrix where every row represents a spike
    %- First column is SNR of each spike
    %- Second column is start time of each spike
    %- Third column is peak time of each spike
    

    
    %% CHANGE THIS ACCORDING TO INPUT PARAMETERS
    %Incorporate with input paramters depending on input?
    

    
    
    
    %% START
    
    %Filter data
    order = 3;
    fcutlow = 0.10;
    fcuthigh = 1;
    fs = 1/(0.132);
    [b,a] = butter(order, [fcutlow,fcuthigh]/(fs/2),'bandpass');
    filtered_sig= filtfilt(b,a,blue);
    filtered_cont = filtfilt(b,a,purple);
    
    %and smooth it
    smoothing = 0.5;
    hw = hanning(2*smoothing+1);   
    filtered_sig = conv(filtered_sig(1:end),hw,'same') / sum(hw);
    filtered_cont = conv(filtered_cont(1:end), hw, 'same') /sum(hw);
    
    %define ratio bins
    s = -5;
    e = 15;
    xs = (s:0.15:e);
    
    %threshold for controls
    lower_th = 1;
    
    %threshold for main channel
    best_th  = 1.5;
    
    purpleMatrix = extract_spikes(purple, purpleT, lower_th, 1/3);
    
    
    %% get good upper threshold data
   
    [blueMatrix, blueSpikeInfo]= extract_spikes(blue, blueT, best_th, 0.5,true,spkSvPath);
    rMatrix = compare_channels(blueMatrix, blueT, purpleMatrix, purpleT, lower_th);
    fin_ratio =  rMatrix(:,1);
    h = histc(fin_ratio, xs);
    %disp(h);
    fin_ratio_start_times = rMatrix(:,2);
    fin_ratio_peak_times = rMatrix(:,3);

    %% smooth histogram
    hw = hanning(2*smoothing_2+1);
    smooth_h = conv(h(1:end),hw,'same') / sum(hw);
    smooth_h = reshape(smooth_h,numel(smooth_h),1);
    


    %% find gaussians fit
    f = fit(xs', smooth_h, 'gauss2');
    
    
    coeffs = coeffvalues(f);
    if(coeffs(2) < coeffs(5))  
        a1 = coeffs(1);
        b1 = coeffs(2);
        c1 = coeffs(3);
        a2 = coeffs(4);
        b2 = coeffs(5);
        c2 = coeffs(6);
    else
        a1 = coeffs(4);
        b1 = coeffs(5);
        c1 = coeffs(6);
        a2 = coeffs(1);
        b2 = coeffs(2);
        c2 = coeffs(3);
    end
    
    %seperate gaussians found from fit
    g1 = @(x) a1*exp(-((x-b1)/c1).^2);
    g2 = @(x) a2*exp(-((x-b2)/c2).^2);  
    
    g1_data = g1(xs);
    g2_data = g2(xs);

%     g1g2 = g1_data + g2_data;
  
    
    %intersection of the two gaussians
    intersection_x = fzero(@(x) g1(x) - g2(x), rand * (b1 - b2) + (b1 + b2));

    %intersection index in xs
%     for i = 1:length(xs)-1
%         if((xs(i) <= intersection_x) && (xs(i+1) > intersection_x))
%             intersection_i = i;
%         end
%     end
    
    
    %% get peaks:
    %peak_indx = dg_findFlattops(g1g2);
    %vally_indx = dg_findFlattops(-1*(g1g2));
    %if(length(peak_indx) < 2)
    %    warning("Not enough peaks found");
    %    return;
    %end
    %if(length(vally_indx) < 1)
    %    warning("No valleys found");
    %    return;
    %end
    
    %find xs and ys of triangle vertices
    tri_x = [b1 b2 intersection_x];
    tri_y = [g1(b1) g2(b2) g1(intersection_x)];
    
    %find area of triangle 
    tri_area = polyarea(tri_x, tri_y);
    


    
    %get smoothed dist up until the peak
    %left_part_dist = smooth_h(1:peak_indx(1));
    %mirrored_left_part = fliplr(left_part_dist(1: end-1));
    %left_part_dist = [left_part_dist' mirrored_left_part'];
        
   
%     disp("The integral");
    
%     il = integral(g1, -Inf, Inf);
%     disp(il);
    %% calculate SNR of recording 
    %cumsum of gaussian 2 until the point of intersection 
    overlap_area_left = integral(g2, -Inf,  intersection_x);
    overlap_area_right = integral(g1, intersection_x, Inf);
    overlap_area = overlap_area_right + overlap_area_left;
    g2_area = integral(g2, -Inf, Inf);
    
    SNR_trace = 1 - overlap_area/g2_area;
    if sum(h(round((intersection_x + 5)/0.15):end)) < 30
        SNR_trace = SNR_trace - 2;
    end
    
    %% calculate SNR for each spike in fin_ratio
    SNR_spikes = [];
    for j = 1:length(fin_ratio)
        SNR_spikes = [SNR_spikes (g2(fin_ratio(j)) - g1(fin_ratio(j)))/(g2(fin_ratio(j)) + g1(fin_ratio(j)) )];
    end
    
    SNR_matrix = [SNR_spikes' fin_ratio_start_times fin_ratio_peak_times];
    %disp(SNR_matrix);

    %fin_ratio_start_times
    %fin_ratio_peak_times =

%     debug = [SNR_spikes' fin_ratio];
%     disp(debug);
    
%     SNR_values = {SNR_matrix SNR_trace};
    
    %% PLOTS for debugging
    if(1)
        fig2 = figure();
        plot(xs, h);
        hold on;
        plot(xs, smooth_h);
        %plot(f, xs, smooth_h);
        plot(xs, g1_data);
        plot(xs, g2_data);

        tri_x = [b1 b2 intersection_x];
        tri_y = [g1(b1) g2(b2) g1(intersection_x)];
        
        
        line( [b1, b2] , [g1(b1), g2(b2)]);
        line( [b2, intersection_x], [g2(b2), g1(intersection_x)]);
        line( [intersection_x, b1], [g1(intersection_x), g1(b1)]);
        
        
        %line( [tri_x(1), tri_x(2)] , [tri_y(1), tri_y(2)]);
        %line( [tri_x(2), tri_x(3)], [tri_y(2), tri_y(3)]);
        %line( [tri_x(3), tri_x(1)], [tri_y(3), tri_y(1)]);
        savefig(fig2, gaussSvPath);
        close(fig2);
    end
%     disp(best_th);
%     disp(tri_area);
end