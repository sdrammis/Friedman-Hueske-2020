function [ states, logpseq ,p_states] = HMM_decode( trials, T, E, thresholds, symbols, raw )
%HMM_DECODE 
% INPUT: 
% raw - depending on whether for get_lick_sequence, the input is in terms
%       of a table of licksInResponse or whether you need to convert it
% OUTPUT: 
% states - table of decoded states!

[lick_sequence, num_trials] = get_lick_sequence(trials, thresholds, symbols, raw);
[p_states, logpseq] = hmmdecode(lick_sequence, T, E, 'Symbols', symbols);

states = zeros(1, num_trials);

for i = 1:num_trials
    state_dist = p_states(:, i);
    [~, index] = max(state_dist);
    states(i) = index;
end
end
