function [FinalTs, FinalEs,changept_final,x,y] = changePointAnalysisBICLine_LR(twdb, mouseID, mouse_type, ideal_size, estimate_E, estimate_T,thresholds,changept)

tone = 1;
symbols = {'S',  'H'};
trials_per_model = 500;
mouse_sessions = lookup2(twdb, 'mouseID', '=', mouseID, 'taskType','=','tt','Order', 'sessionDate', 'ASC');

size_of_session = size(mouse_sessions); 
number_of_sessions = size_of_session(2);
all_sessions = cell(1, number_of_sessions);
total_trials = 0 ;
for session = 1:number_of_sessions %accesses it from last to first
    access_session = mouse_sessions(session);
    data_for_session = struct2table(access_session.trialData);
    all_sessions{1, session} = data_for_session;
    total_trials = total_trials + height(all_sessions{1,session});
end

%number_of_sessions = ceil(total_trials/ideal_size);

tot = 0;
init_trials = [0];
for i = 1:number_of_sessions
    tot = tot + height(all_sessions{1,i});
    init_trials = [init_trials tot];
end

overall = [ ] ;
Ts = cell(1,number_of_sessions);
Es = cell(1,number_of_sessions);

for half=0:1
    for session_step=1:number_of_sessions
        initial_session = session_step;
        session_counter = initial_session;
        current_height = 0;
        HMM_training_session = cell(1,1);
        used_sessions = "";
        
        while current_height < ideal_size
            if session_counter > length(all_sessions)
                break
            end
            
            %getting correct session
            current_session = all_sessions{session_counter};
            %getting stimulus 1
            
            current_session = current_session(current_session.StimulusID == tone, :);
            %populating HMM_training_session with needed trials
            if height(current_session) > trials_per_model
                used_sessions = strcat(used_sessions, int2str(session_counter), ',');
                %takes the first trials_per_model from model 
                if half
                    if ~isempty(HMM_training_session{1})
                        if height(HMM_training_session{1}) + trials_per_model > ideal_size
                            up_to = ideal_size - height(HMM_training_session{1});
                            to_add = current_session(1:up_to, :);
                        else
                            to_add = current_session(1:trials_per_model, :);
                        end
                    else
                        to_add = current_session(1:trials_per_model, :);
                    end
                
                %takes the last trials_per_model from model
                else
                    if ~isempty(HMM_training_session{1})
                        if height(HMM_training_session{1}) + trials_per_model > ideal_size
                            down_to = ideal_size - height(HMM_training_session{1});
                            to_add = current_session(height(current_session)- down_to+1 : end, :);
                        else
                            to_add = current_session(height(current_session)-trials_per_model:end, :);
                        end
                    else
                        to_add = current_session(height(current_session)-trials_per_model:end, :);
                    end
                end
            else
                used_sessions = strcat(used_sessions, int2str(session_counter), ',');
                if ~isempty(HMM_training_session{1})
                    if height(HMM_training_session{1}) + height(current_session) > ideal_size
                        up_to = ideal_size - height(HMM_training_session{1});
                        to_add = current_session(1:up_to, :);
                    else
                        to_add = current_session(:, :);
                    end
                else
                    to_add = current_session(:, :);
                end    
            end
            
            %populating HMM_training_session with to_add
            if width(to_add) == 20
                    to_add = removevars(to_add, 'Engagement');
            end
                
            if isempty(HMM_training_session{1})
                HMM_training_session{1} = to_add;
            else
                if width(to_add) == 20
                    to_add = removevars(to_add, 'Engagement');
                end
                HMM_training_session{1} = [HMM_training_session{1}; to_add];
            end

            %updating counters
            session_counter = session_counter + 1;
            if ~isempty(HMM_training_session{1})
               current_height = height(HMM_training_session{1});
            end

        end

        if session_counter > length(all_sessions)
            break
        end
        
        [ Ts{session_step}, Es{session_step}, logs ] = HMM_train(HMM_training_session{1}, estimate_T, estimate_E, thresholds, symbols, false);    
        
        nObs = height(HMM_training_session{1});
        
        nParams = 8;
        [~, BIC] = aicbic(logs(end), nParams, nObs); 

        total_rows = height(HMM_training_session{1});
        
        initial_trial = init_trials(initial_session);
        update = [initial_trial, initial_session , session_counter , trials_per_model , half, total_rows, used_sessions, BIC ];
        
        overall = [ overall ; update ];
    end
end
only_first_half = size(overall,1)/2;
if ~isempty(overall)
    y = str2double(overall(1:only_first_half ,8));
    x = str2double(overall(1:only_first_half ,1));
end

if isempty(changept)
    dif = [];
    for i = 2:length(y)
        dif = [dif y(i)-y(i-1)];
    end

    [maxBICdif, maxBICdif_ind] = max(dif);
    changept_final = str2double(overall(maxBICdif_ind+1));
    half_low = floor((maxBICdif_ind+1)/2);
    FinalTs = {Ts{half_low}, Ts{maxBICdif_ind+1}};
    FinalEs = {Es{half_low}, Es{maxBICdif_ind+1}};

end

if ~isempty(changept)
    FinalTs = cell(1,length(changept)+1);
    FinalEs = cell(1,length(changept)+1);
    c1 = 0;
    c2 = 0 
    for i = 1:length(changept)
        for j = 2:only_first_half
            if changept(i) > str2num(overall(j-1)) && changept(i) < str2num(overall(j))
                FinalTs{1,i} = Ts{j-1};
                FinalEs{1,i} = Es{j-1};
            end
        end
        
    end
    % changing from {1,3} to {1,2} temporarily
    if length(changept) == 1
        FinalTs{1,2} =Ts{1,only_first_half-1}
        FinalEs{1,2} = Es{1,only_first_half-1}
    else
       FinalTs{1,3} =Ts{1,only_first_half-1}
       FinalEs{1,3} = Es{1,only_first_half-1} 
    end
    changept_final = changept;
end

%figure(1)
%plot(dif)

plot(x,y) 
ylabel("BIC");
xlabel("starting session");
title(strcat("BIC over sessions for trial size: ", int2str(ideal_size),'-',mouse_type, '-',mouseID));
[minimum, min_index] = min(str2double(overall(1:only_first_half,8)));
min_index = init_trials(min_index);
[maximum, max_index] = max(str2double(overall(1:only_first_half,8)));
max_index = init_trials(max_index);
result = [minimum, min_index, maximum, max_index];

%fileID = fopen("MinMax.txt", 'a');
%fprintf(fileID, strcat('\n',mouse_type,int2str(input),'-',int2str(ideal_size),': ',mat2str(result)));
%fclose(fileID);
end