function miceIDs = get_mouse_ids(twdb,taskReversal,health,learned,...
    intendedStriosomality,histologyStriosomality,age,photometry,exceptions)

mice_idx = 1:length(twdb);

if ~isequal(health,'all')
    mice_idx = cell2mat(twdb_lookup(twdb(mice_idx),'index','key','Health',health));
end

if ~isequal(intendedStriosomality,'all')
    mice_idx = cell2mat(twdb_lookup(twdb(mice_idx),'index','key','intendedStriosomality',intendedStriosomality));
end

if ~isequal(histologyStriosomality,'all')
    mice_idx = cell2mat(twdb_lookup(twdb(mice_idx),'index','key','histologyStriosomality',histologyStriosomality));
end


if ~isequal(age,'all')
    ageCutoff = 15;
    if isequal(age,'old')
        mice_idx = cell2mat(twdb_lookup(twdb(mice_idx),'index','grade','firstSessionAge',ageCutoff+1,Inf));
    elseif isequal(age,'young')
        mice_idx = cell2mat(twdb_lookup(twdb(mice_idx),'index','grade','firstSessionAge',0,ageCutoff));
    end
end

miceIDs = unique(twdb_lookup(twdb(mice_idx),'mouseID'));

if ~isequal(photometry,'all')
    for n = 1:length(miceIDs)
        
        if sum(~cellfun(@isempty,twdb_lookup(twdb(mice_idx),'raw470Session','key',...
            'mouseID',miceIDs{n}))) && first(twdb_lookup(twdb(mice_idx),'positive','key',...
            'mouseID',miceIDs{n}))
            photometry_animals(n) = true;
        else
            photometry_animals(n) = false;
        end
    end
    if photometry
        miceIDs(~photometry_animals) = [];
    else
        miceIDs(photometry_animals) = [];
    end
end

if ~isequal(learned,'all')   
    for n = 1:length(miceIDs)
        if ~taskReversal
            learnedFirstTask = first(twdb_lookup(twdb(mice_idx),'learnedFirstTask','key',...
                'mouseID',miceIDs{n}));
            learned_animals(n) = (learnedFirstTask ~= -1);
        else
            learnedReversalTask = first(twdb_lookup(twdb(mice_idx),'learnedReversalTask','key',...
                'mouseID',miceIDs{n}));
            learned_animals(n) = (learnedReversalTask ~= -1);
        end
    end
    if learned
        miceIDs(~learned_animals) = [];
    else
        miceIDs(learned_animals) = [];
    end
end
if taskReversal
    for n = 1:length(miceIDs)
        taskTypes = unique(twdb_lookup(twdb(mice_idx),'taskType','key',...
            'mouseID',miceIDs{n}));
        taskNum_animals(n) = length(taskTypes);
    end
    miceIDs = miceIDs(taskNum_animals == 2);
end

for n = 1:length(exceptions)
    miceIDs(cellfun(@(x)isequal(x,exceptions{n}),miceIDs)) = [];
end
