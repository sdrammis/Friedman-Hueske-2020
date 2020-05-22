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


% function [distance_dist,bins,distances] = hist_distances(spikes, trial_num, bin_edges, threshold)
% distance_dist = [];
% bins = [];
% distances = [];
% for trial = unique(trial_num)
%     trial_spikes = spikes(trial_num==trial);
%     trial_spikes = sort(cell2mat(trial_spikes(:))); % spikes in ascending order
%     trial_bin_edges = bin_edges(trial_num==trial,:);
%     
%     contig_spikes = [];
%     for jj=1:size(trial_bin_edges,1)
%         start = trial_bin_edges(jj,1);
%         stop = trial_bin_edges(jj,2);
%         bin_spikes = trial_spikes(trial_spikes >= start & trial_spikes <= stop)';
%         
%         if jj == 1 || start == trial_bin_edges(jj-1,2)
%             contig_spikes = [contig_spikes bin_spikes];
%         else
%             if length(contig_spikes) < threshold
%                 contig_spikes = bin_spikes;
%                 continue;
%             end
%             
%             for idx = 2:length(contig_spikes)
%                 distances = [distances (contig_spikes(idx) - contig_spikes(idx-1))];
%             end
%             contig_spikes = bin_spikes;
%         end     
%     end
%     if length(contig_spikes) >= threshold
%         for idx = 2:length(contig_spikes)
%             distances = [distances (contig_spikes(idx) - contig_spikes(idx-1))];
%         end
%     end
% end
% if length(distances) >= 1
%     [distance_dist, bins] = histcounts(distances,20,'Normalization', 'probability');
% end

