function [miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials_eng(twdb, mouseID, engaged, notEngaged, changepts,include_deevaluate)
   
    miceTrials = cell(5,1);
    miceFluorTrials = cell(5,1);
    rewardTones = zeros(1,1);
    costTones = zeros(1,1);
    all_trials = table;
    all_fluor = [];
   
    for i = 1:length(engaged)
        if istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
        elseif ~istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            names = notEngaged{i}.Properties.VariableNames;
            engaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        elseif istable(engaged{i}) && ~istable(notEngaged{i})
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
            names = engaged{i}.Properties.VariableNames;
            notEngaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        end
        
    end

    trials = [];
    for i = 1:length(engaged) 
        trials = [trials; engaged{i}; notEngaged{i}];    
    end

    trials = sortrows(sortrows(trials, 'IDXofTrial'), 'SessionNumber');
    sessionIdx = get_mouse_sessions(twdb,mouseID,1,include_deevaluate,'all',0);

    mouseTrials_1 = table;
    mouseTrials_2 = table;
    mouseTrials_3 = table;
    mouseTrials_4 = table;
    mouseTrials_5 = table;
    
    fluorTrials_1 = [];
    fluorTrials_2 = [];
    fluorTrials_3 = [];
    fluorTrials_4 = [];
    fluorTrials_5 = [];
    
    
    for idx = sessionIdx
        trialData = twdb(idx).trialData;
        [sessFluorTrials] = get_session_fluorescence_sta_LR(twdb, mouseID, idx, 'all', false);
        if isempty(sessFluorTrials)
            all_fluor = [all_fluor; nan(height(trialData),98)];
            continue;
        end
        
        sessFluorAll = get_session_fluorescence_sta_LR(twdb, mouseID, idx, 'all', true);
        numSessionTrials = size(sessFluorTrials, 1);
        for i=1:numSessionTrials
            zSessFluor = zscore_baseline(sessFluorTrials(i, :), sessFluorAll);
            all_fluor = [all_fluor; zSessFluor];
        end
    end

    if length(changepts) == 4
        for i = 1:length(all_fluor)
            if i <= changepts(1)
                mouseTrials_1 = [mouseTrials_1; trials(i,:)];
                fluorTrials_1 = [fluorTrials_1; all_fluor(i,:)];
            end
            if i > changepts(1) && i <= changepts(2)
                mouseTrials_2 = [mouseTrials_2; trials(i,:)];
                fluorTrials_2 = [fluorTrials_2; all_fluor(i,:)];
            end
            if i > changepts(2) && i <= changepts(3)
                mouseTrials_3 = [mouseTrials_3; trials(i,:)];
                fluorTrials_3 = [fluorTrials_3;all_fluor(i,:)];
            end
            if i > changepts(3) && i <= changepts(4)
                mouseTrials_4 = [mouseTrials_4; trials(i,:)];
                fluorTrials_4 = [fluorTrials_4;all_fluor(i,:)];
            end
            if i > changepts(4) 
                mouseTrials_5 = [mouseTrials_5; trials(i,:)];
                fluorTrials_5 = [fluorTrials_5;all_fluor(i,:)];
            end
        end
    end
    
    
    if length(changepts) == 3
        for i = 1:length(all_fluor)
            if i <= changepts(1)
                mouseTrials_1 = [mouseTrials_1; trials(i,:)];
                fluorTrials_1 = [fluorTrials_1; all_fluor(i,:)];
            end
            if i > changepts(1) && i <= changepts(2)
                mouseTrials_2 = [mouseTrials_2; trials(i,:)];
                fluorTrials_2 = [fluorTrials_2; all_fluor(i,:)];
            end
            if i > changepts(2) && i <= changepts(3)
                mouseTrials_3 = [mouseTrials_3; trials(i,:)];
                fluorTrials_3 = [fluorTrials_3;all_fluor(i,:)];
            end
            if i > changepts(3) 
                mouseTrials_4 = [mouseTrials_4; trials(i,:)];
                fluorTrials_4 = [fluorTrials_4;all_fluor(i,:)];
            end
        end
    end
    
    if length(changepts) == 2
        for i = 1:length(all_fluor)
            if i <= changepts(1)
                mouseTrials_1 = [mouseTrials_1; trials(i,:)];
                fluorTrials_1 = [fluorTrials_1; all_fluor(i,:)];
            end
            if i > changepts(1) && i <= changepts(2)
                mouseTrials_2 = [mouseTrials_2; trials(i,:)];
                fluorTrials_2 = [fluorTrials_2; all_fluor(i,:)];
            end
            if i > changepts(2)
                mouseTrials_3 = [mouseTrials_3; trials(i,:)];
                fluorTrials_3 = [fluorTrials_3;all_fluor(i,:)];
            end
        end
    end
    
    if length(changepts) == 1
        for i = 1:height(trials)
            if i <= changepts(1)
                mouseTrials_1 = [mouseTrials_1; trials(i,:)];
                fluorTrials_1 = [fluorTrials_1; all_fluor(i,:)];
            end
            if i > changepts(1)
                mouseTrials_2 = [mouseTrials_2; trials(i,:)];
                fluorTrials_2 = [fluorTrials_2; all_fluor(i,:)];
            end
        end
    end

    miceTrials{1,1} = mouseTrials_1;
    miceTrials{2,1} = mouseTrials_2;
    miceTrials{3,1} = mouseTrials_3;
    miceTrials{4,1} = mouseTrials_4;
    miceTrials{5,1} = mouseTrials_5;
    miceFluorTrials{1,1} = fluorTrials_1;
    miceFluorTrials{2,1} = fluorTrials_2;
    miceFluorTrials{3,1} = fluorTrials_3;
    miceFluorTrials{4,1} = fluorTrials_4;
    miceFluorTrials{5,1} = fluorTrials_5;
    rewardTones(1) = twdb(idx).rewardTone;
    costTones(1) = twdb(idx).costTone;

end

function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end