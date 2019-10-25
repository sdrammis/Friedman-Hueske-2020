classdef HMM_trainer
    %HMM_trainer Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Thresholds = [3]
        Symbols = {'S', 'H'}
        LickSequence
        MaxIterations = 2000
    end

    methods (Access = public)
        function [seq] = get_lick_sequence(obj, trials)
            %get_lick_sequence Generate sequence of symbols representing
            %licks to use in HMM analysis
            %
            % Input  ::  obj                     - object
            %            trials                  - trials to get sequence for
            %
            % Output ::  seq                     - sequence (cell array) of
            %                                       symbols, where each
            %                                       symbol represents the
            %                                       label on a specific
            %                                       trial

            raw_licks = trials.LicksInResponse;
            num_trials = length(raw_licks);

            seq = cell(1, num_trials);

            num_thresh = length(obj.Thresholds);
            num_bins = num_thresh + 1;

            if num_bins ~= length(obj.Symbols)
                error(['Number of thresholds (' num2str(num_thresh) ') given does not match number of labels (' num2str(length(obj.Symbols)) ')'])
            end

            for i = 1:num_trials
                num_licks = raw_licks(i);
                binned = false;

                j = 1;
                while ~binned
                    if j > num_thresh
                        seq{i} = obj.Symbols{end};
                        binned = true;
                        continue
                    end

                    threshold = obj.Thresholds(j);

                    if num_licks < threshold
                        seq{i} = obj.Symbols{j};
                        binned = true;
                    end

                    j = j + 1;
                end
            end
        end

        function [engaged_trials, non_engaged_trials] = train(obj, trials, estimate_T, estimate_E, tone)
            % Only TRAIN on trials for correct Tone
            training_set = trials(trials.StimulusID == tone, :);

            obj.LickSequence = obj.get_lick_sequence(training_set);
            [T, E, ~, ~] = obj.HMM_train(estimate_T, estimate_E);
            states = obj.HMM_decode(T, E);

            [Estates, ~, ~] = obj.HMM_interpret(E, states);
            [engaged_trials, non_engaged_trials] = obj.HMM_trials(trials, Estates);
        end
    end

    methods (Access = private)
        % HMM ANALYSIS (in order)
        function [T, E, converged, logliks] = HMM_train(obj, estimate_T, estimate_E)
            %HMM_train Function used to train T and E matrices for HMM_decode
            %   Input  :: obj                     - object
            %             estimate_T              - estimate for T matrix (2x2 double)
            %             estimate_E              - estimate for E matrix (2x2 double)
            %
            %   Output :: T                       - trained T matrix (2x2 double)
            %             E                       - trained E matrix (2x2 double)
            %             converged               - whether the model converged or not
            %             logliks                 - Matlab calculated log likelihoods

            lick_sequence = obj.LickSequence;
            [T, E, logliks, converged] = hmmtrain(lick_sequence, estimate_T, estimate_E, 'Symbols', obj.Symbols, 'MAXITERATIONS', obj.MaxIterations);
        end

        function [states] = HMM_decode(obj, T, E)
            %HMM_decode Function used to decode states given trained T and E from HMM_train
            %   Input  :: obj                     - object
            %             T                       - trained T from HMM_train
            %             E                       - trained E from HMM_train
            %
            %   Output :: states                   - table of decoded states, will be in
            %                                           the form of the symbols input

            lick_sequence = obj.LickSequence;
            num_trials = length(lick_sequence);

            p_states = hmmdecode(lick_sequence, T, E, 'Symbols', obj.Symbols);

            states = zeros(1, num_trials);

            for i = 1:num_trials
                state_dist = p_states(:, i);
                [~, index] = max(state_dist);
                states(i) = index;
            end
        end

        function [Fstates, Ecount, Ncount] = HMM_interpret(obj, E, states)
            % HMM_interpret Function used to interpret raw decoded states from
            %               HMM_decode, based on emission matrix and the raw data
            %   Input  :: obj                     - object
            %             E                   - trained E matrix from HMM_train
            %             states              - raw engaged states from HMM_decode
            %
            %   Output :: Fstates             - Decoded states rewritten with 1's as
            %                                       engaged states and 0's as not engaged states
            %             Ecount              - total number of engaged states
            %             Ncount              - total number of not engaged states


            seq = obj.LickSequence;

            % over all state 2's, is ratio of S:H closer to E(1)/E(3) or E(2)/E(4)
            % if so, is ratio of state 1 equal to the other?
            one_small = 0;
            one_high = 0;
            two_small = 0;
            two_high = 0;

            for v=1:length(states)
                if states(v) == 2
                    if seq{v} == 'S'
                        two_small = two_small + 1;
                    elseif seq{v} == 'H'
                        two_high = two_high + 1;
                    end
                elseif states(v) == 1
                    if seq{v} == 'S'
                        one_small = one_small + 1;
                    elseif seq{v} == 'H'
                        one_high = one_high + 1;
                    end
                end
            end
            if one_high == 0
                one_high = 1;
            end
            if two_high == 0
                two_high = 1;
            end


            one_ratio = one_small / one_high;
            two_ratio = two_small / two_high;

            if E(3) < .01
                E(3) = .01;
            end
            if E(4) < .01
                E(4) = .01;
            end

            E_ratio = E(1) / E(3);
            NE_ratio = E(2) / E(4);


            Estates = strings(1, length(states));

            Ncount = 0;
            Ecount = 0;
            for v = 1:length(states)
                if (abs(one_ratio - E_ratio) < abs(two_ratio - E_ratio)) && (abs(one_ratio - NE_ratio) > abs(two_ratio - NE_ratio))
                    if states(v) == 1
                        Estates(v) = 'E';
                        Ecount = Ecount + 1;
                    elseif states(v) == 2
                        Estates(v) = 'N';
                        Ncount = Ncount + 1;
                    end

                elseif (abs(one_ratio - E_ratio) > abs(two_ratio - E_ratio)) && abs(one_ratio - NE_ratio) < abs(two_ratio - NE_ratio)
                    if states(v) == 1
                        Estates(v) = 'N';
                        Ncount = Ncount + 1;
                    elseif states(v) == 2
                        Estates(v) = 'E';
                        Ecount = Ecount + 1;

                    end
                elseif (abs(one_ratio - E_ratio) < abs(two_ratio - E_ratio)) && (abs(one_ratio - NE_ratio) < abs(two_ratio - NE_ratio))
                    if states(v) == 1
                        Estates(v) = 'E';
                        Ecount = Ecount + 1;
                    elseif states(v) == 2
                        Estates(v) = 'N';
                        Ncount = Ncount + 1;
                    end
                elseif (abs(one_ratio - E_ratio) > abs(two_ratio - E_ratio)) && abs(one_ratio - NE_ratio) > abs(two_ratio - NE_ratio)
                    if states(v) == 1
                        Estates(v) = 'N';
                        Ncount = Ncount + 1;
                    elseif states(v) == 2
                        Estates(v) = 'E';
                        Ecount = Ecount + 1;

                    end
                end
            end


            Fstates = zeros([1, length(Estates)]);
            for v =1:length(Estates)
                if Estates(v) == 'E'
                    Fstates(v) = 1 ;
                elseif Estates(v) == 'N'
                    Fstates(v) = 0 ;


                end
            end

        end

        function [Etrials, Ntrials] = HMM_trials(obj, trials, Estates)
            %  HMM_trials Function used to convert intrepreted states from
            %               HMM_interpret into actual trials
            %
            %   Input  :: E                   - trained E matrix from HMM_train
            %             Estates             - Interpreted states from
            %                                       HMM_interpret
            %
            %   Output :: Etrials             - table of all engaged trials
            %             Ntrials             - table of all non-engaged trials

            Ntrials = [];
            Etrials = [];
            one_count = 0;
            for v = 1:height(trials)
                if trials.StimulusID(v) == 1
                    one_count = one_count + 1;
                    if one_count > length(Estates)
                        one_count = one_count - 1;
                    end
                    if Estates(one_count) == 0
                        Ntrials = [Ntrials; trials(v, :)];
                    elseif Estates(one_count) == 1
                        Etrials = [Etrials; trials(v, :)];
                    end

                elseif trials.StimulusID(v) == 2
                    if one_count == 0
                        one_count = 1;
                    end

                    if Estates(one_count) == 0
                        Ntrials = [Ntrials; trials(v, :)];
                    elseif Estates(one_count) == 1
                        Etrials = [Etrials; trials(v, :)];
                    end
                end
            end
        end
    end
end
