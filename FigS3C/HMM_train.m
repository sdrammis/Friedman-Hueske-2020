function [ T, E, logliks] = HMM_train( trials, estimate_T, estimate_E, thresholds, symbols, raw ) 
%HMM_train Function used to train T and E matrices for HMM_decode
%   Input  :: trials                  - trial data to train on
%             estimate_T              - estimate for T matrix (2x2 double)
%             estimate_E              - estimate for E matrix (2x2 double)
%             thresholds              - thresholds for what is considered a
%                                           low or high number of licks
%             symbols                 - symbols indicating small num licks
%                                           or high num licks
%             raw                     - true/false, used for get_lick_sequence
%                                           (true if trialData, false if LicksInResponse)
%
%   Output :: T                       - trained T matrix (2x2 double)
%             E                       - trained E matrix (2x2 double)
%             converged               - whether the model converged or not
%             logliks                 - Matlab calculated log likelihoods

[lick_sequence, ~] = get_lick_sequence(trials, thresholds, symbols, raw);
[T, E, logliks] = hmmtrain(lick_sequence, estimate_T, estimate_E, 'Symbols', symbols, 'MAXITERATIONS', 2000);

end

