function [ T, E, logliks ,converged] = HMM_train( trials, estimate_T, estimate_E, thresholds, symbols, raw ) 

[lick_sequence, ~] = get_lick_sequence(trials, thresholds, symbols, raw);
[T, E, logliks,converged] = hmmtrain_final(lick_sequence, estimate_T, estimate_E, 'Symbols', symbols, 'MAXITERATIONS', 2000);