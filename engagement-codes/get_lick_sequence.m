function [seq, num_trials] = get_lick_sequence( trials, thresholds, symbols, raw )
    
    if raw == true
        raw_licks = trials;
    else %raw == false
        raw_licks = [trials.LicksInResponse];
    end
    
    num_trials = length(raw_licks);
    
    seq = cell(1, num_trials);
    
    num_thresh = length(thresholds);
    num_bins = num_thresh + 1;
   
    if num_bins ~= length(symbols)
        error(['Number of thresholds (' num2str(num_thresh) ') given does not match number of labels (' num2str(length(symbols)) ')'])
    end
    
    for i = 1:num_trials
        num_licks = raw_licks(i);
        
        binned = false;
        
        j = 1;
        while ~binned
            if j > num_thresh
                seq{i} = symbols{end};
                binned = true;
                continue
            end
            
            threshold = thresholds(j);
            
            if num_licks < threshold
                seq{i} = symbols{j};
                binned = true;
            end
            
            j = j + 1;
        end
    end
end