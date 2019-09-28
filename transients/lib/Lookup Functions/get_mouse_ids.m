function miceIDs = get_mouse_ids(twdb,taskType,health,learned,exceptions)

if isequal(taskType,'all')
    miceIDs = unique(twdb_lookup(twdb,'mouseID'));
else
    miceIDs = unique(twdb_lookup(twdb,'mouseID','key','Health',health,'key','taskType',taskType));
end

for n = 1:length(exceptions)
    miceIDs(cellfun(@(x)isequal(x,exceptions{n}),miceIDs)) = [];
end

for n = 1:length(miceIDs)
    learnedTT = twdb_lookup(twdb,'learnedTT','key','mouseID',miceIDs{n},...
        'key','taskType',taskType,'key','sessionNumber',1);
    learned_animals(n) = (learnedTT{1} ~= -1);
end

if ~isequal(learned,'all')   
    if learned
        miceIDs(~learned_animals) = [];
    else
        miceIDs(learned_animals) = [];
    end
end