function write_chunky_commands(trialDataDB_file)

load(trialDataDB_file)
miceIDs = {trialDataDB(:).mouseID};

fileID = fopen('chunky_input.txt', 'w');
% outDir = '/vicepf/home/sebatoro/Final/Data';
outDir = '/vicepf/home/sebatoro/Final/Reversal Data';
num_states = [2,3];
lick_threshold = [1,2,3];
window_size = {'300','600','1200','2400','4000','8000','all'};
transition_init = [1,2];
all_tones = [0,1];
for mouseIdx = 1:length(miceIDs)
    mouseID = miceIDs{mouseIdx};
    for state = num_states
        for threshold = lick_threshold
            for w = 1:length(window_size)
                for tone = all_tones
                    if state == 3
                        for init = transition_init
                            fprintf(fileID,[trialDataDB_file,'.mat#%s#%d#%d#%s#%d#%d#%s\n'],...
                            mouseID,state,threshold,window_size{w},...
                            init,tone,outDir);
                        end
                    else
                        fprintf(fileID,[trialDataDB_file '.mat#%s#%d#%d#%s#%d#%d#%s\n'],...
                        mouseID,state,threshold,window_size{w},...
                        1,tone,outDir);
                    end
                end
            end
        end
    end
end
fclose(fileID);