function [miceTrials,miceFluorTrials470,miceFluorTrials405,rewardTones,costTones,numSessions] = get_all_trials_edit2QZ(twdb,miceIDs,upToLearned,reversal,period)
    
    miceTrials = cell(1,length(miceIDs));
    miceFluorTrials470 = cell(1,length(miceIDs));
    miceFluorTrials405 = cell(1,length(miceIDs));
    rewardTones = zeros(1,length(miceIDs));
    costTones = zeros(1,length(miceIDs));
    numSessions = zeros(1,length(miceIDs));
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        sessionIdx = get_mouse_sessions(twdb,mouseID,~reversal,0,'all',0);
        
        mouseTrials = table;
        fluorTrials470 = [];
        fluorTrials405 = [];
        for idx = sessionIdx
            trialData = twdb(idx).trialData;
            if isempty(trialData) % || width(trialData) <= 12 % modify based on database
                continue
            end
            mouseTrials = [mouseTrials; trialData(:,1:12)];
            engagement = 'all';
            [sessFluorTrials470,sessFluorTrials405,timeTrials470,...
                timeTrials405] = get_session_fluorescence_sta_edit2QZ(twdb,...
                mouseID,idx,engagement,false,period);
            cont = 0;
            if isempty(sessFluorTrials470)
                fluorTrials470 = [fluorTrials470; nan(height(trialData),1)];
                cont = 1;
            end
            if isempty(sessFluorTrials405)
                fluorTrials405 = [fluorTrials405; nan(height(trialData),1)];
                cont = 1;
            end
            if cont
%                 disp(size(fluorTrials470));
%                 disp(size(fluorTrials405));
                continue;
            end
            
            sessFluorAll = get_session_fluorescence_sta_edit2QZ(twdb,mouseID,idx,engagement,true,period);
            numSessionTrials470 = length(sessFluorTrials470);
            numSessionTrials405 = length(sessFluorTrials405);
%             disp(size(sessFluorTrials470));
%             disp(size(sessFluorAll));
            if numSessionTrials470 ~= numSessionTrials405
                disp('405 and 470 not same numSessionTrials!')
            end
            for i=1:numSessionTrials470
                if isempty(sessFluorTrials470{i})
                    fluorTrials470 = [fluorTrials470; NaN];
                else
                    zSessFluor470 = zscore_baseline(sessFluorTrials470{i}, sessFluorAll{1});
                    fluorTrials470 = [fluorTrials470; nansum(zSessFluor470)/timeTrials470{i}];
                end
                if isempty(sessFluorTrials405{i})
                    fluorTrials405 = [fluorTrials405; NaN];
                else
                    zSessFluor405 = zscore_baseline(sessFluorTrials405{i}, sessFluorAll{1});
                    fluorTrials405 = [fluorTrials405; nansum(zSessFluor405)/timeTrials405{i}];
                end
            end
        end

        if upToLearned
            if ~reversal
                learnedFirstTask = first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', mouseID));
                if learnedFirstTask ~= -1
                    disp(size(mouseTrials))
                    disp(learnedFirstTask)
                    mouseTrials = mouseTrials(1:learnedFirstTask,:);
%                     disp(size(fluorTrials470));
%                     disp(size(fluorTrials405));
%                     disp(learnedFirstTask);
                    fluorTrials470 = fluorTrials470(1:learnedFirstTask,:);
                    fluorTrials405 = fluorTrials405(1:learnedFirstTask,:);
                end
            else
                learnedReversalTask = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', mouseID));
                if learnedReversalTask ~= -1
                    mouseTrials = mouseTrials(1:learnedReversalTask,:);
                    fluorTrials470 = fluorTrials470(1:learnedReversalTask,:);
                    fluorTrials405 = fluorTrials405(1:learnedReversalTask,:);
                end
            end
        end
        
        miceTrials{m} = mouseTrials;
        miceFluorTrials470{m} = fluorTrials470;
        miceFluorTrials405{m} = fluorTrials405;
        rewardTones(m) = twdb(idx).rewardTone;
        costTones(m) = twdb(idx).costTone;
        numSessions(m) = length(sessionIdx);
    end
end

function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end