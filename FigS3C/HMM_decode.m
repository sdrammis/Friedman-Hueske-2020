function [ states ] = HMM_decode( trials, T, E, thresholds, symbols, raw )
%HMM_decode Function used to train T and E matrices for HMM_decode
%   Input  :: trials                  - trial data to train on
%             T                       - trained T from HMM_train
%             E                       - trained E from HMM_train
%             thresholds              - thresholds for what is considered a
%                                           low or high number of licks
%             symbols                 - symbols indicating small num licks
%                                           or high num licks
%             raw                     - true/false, used for get_lick_sequence
%                                           (true if trialData, false if LicksInResponse)
%
%   Output :: states                   - table of decoded states, will be in
%                                           the form of the symbols input


[lick_sequence, num_trials] = get_lick_sequence(trials, thresholds, symbols, raw);
p_states = hmmdecode(lick_sequence, T, E, 'Symbols', symbols);

states = zeros(1, num_trials);

for i = 1:num_trials
    state_dist = p_states(:, i);
    [~, index] = max(state_dist);
    states(i) = index;
end

end

