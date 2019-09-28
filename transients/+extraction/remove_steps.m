function clean_traces = remove_steps(synced_traces, clean_th, all_th, window_half_width)
%%
%Inputs:
%- r x c matrix of synchronized traces synced_traces where each column
%correpsonds to a trace
%- a double as a threshold for how many standard deviations of
%diff(trace) to set the cutoff threshold.
%
%The function differentiates the traces and removes the jumps common in
%%all of them above the threshold th as well as any huge jumps in the channel with the minimum
%standard deviation, then integrates and returns the traces as an r x c matrix clean_traces

%% Start

%get dimensions
[r,c] = size(synced_traces);

%differentaiated traces
dt_traces = diff(synced_traces);
%means of diff traces
mn_diffs = mean(dt_traces);
%std of diff traces
sd_diffs = std(dt_traces);


%% Plot diff and original only
if(0)
    for j=1:c
        f = figure();
        %subplot(c,1,j);
        plot(dt_traces(:,j));
        hold on;
        plot(synced_traces(:,j) - min(synced_traces(:,j)));
        hold off;
    end
end

%%
%get index of the best looking trace
[~, best_trace_index]=  min(sd_diffs);


cutoff = mn_diffs(best_trace_index) + sd_diffs(best_trace_index)*clean_th;
cutoffs = mn_diffs + sd_diffs*all_th;

null_indices = [];


for i = 1:r-1
    %if value in the best looking trace exceeds its th
    if(abs(dt_traces(i,best_trace_index)) > cutoff)
        
        null_indices = [null_indices i];
        
        dt_traces(i,:) = zeros(1,c);  %replace with zeros
        for w = 1:window_half_width
            dt_traces(max(i-w,1),:) = zeros(1,c);
            dt_traces(min(i+w,r-1),:) = zeros(1,c);
        end
        
        %if all elements of row are bigger than their threshold
    elseif(prod(abs(dt_traces(i,:)) > cutoffs))
        null_indices = [null_indices i];
        dt_traces(i,:) = zeros(1,c);
        
        for w = 1:window_half_width
            dt_traces(max(i-w,1),:) = zeros(1,c);
            dt_traces(min(i+w,r-1),:) = zeros(1,c);
        end
    end
end

% include the initial value to integrate
dt_traces = [synced_traces(1,:); dt_traces];

clean_traces = cumsum(dt_traces);

%plot before and after traces
%f = figure();

%     for j=1:c
%         f = figure();
%         %subplot(c,1,j);
%         plot(synced_traces(:,j) - min(synced_traces(:,j)));
%         hold on;
%         plot(clean_traces(:,j) - min(clean_traces(:,j)));
%         hold off;
% %         xlim([22800 23200]);
%     end

%Set removed regions to NaN
for i = null_indices
    clean_traces(i,:) = ones(1,c)*NaN;
    for w = 1:window_half_width
        clean_traces(max(i-w,1),:) = ones(1,c)*NaN;
        clean_traces(min(i+w,r),:) = ones(1,c)*NaN;
    end
end

end
