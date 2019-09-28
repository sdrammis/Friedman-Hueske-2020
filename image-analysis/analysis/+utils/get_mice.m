function mice = get_mice(miceDB, varargin)
% Returns a struct of mice filtered on arguments
% Options:
%   'health', ["WT", "HD"]
%   'striosomality', ["Strio", "Matrix"]
%   'learned'
%   'learned-old', twdb
%   'not-learned'
%   'not-learned-old'
% example: get_mice(miceType, 'health', ["WT", "HD"], ...
%   'intendedStriosomality', "Strio", 'learned-old', twdb);

% Filter out DREADD animals by default
% NOTE: We may need to change this
f = fieldnames(miceDB)';
f{2,1} = {};
mice = struct(f{:});

for i=1:length(miceDB)
    mouse = miceDB(i);
    if isempty(mouse.DREADDType)
        mice = [mice mouse];
    end
end
mice = update_idxs(mice);


n = length(varargin);
if n == 0
    return;
end

i = 1;
while i <= n
    arg = varargin{i};
    switch arg
        case 'health'
            mice = select_or(mice, 'Health', varargin{i+1});
            i = i + 2;
        case 'striosomality'
            mice = select_or(mice, 'intendedStriosomality', varargin{i+1});
            i = i + 2;
        case 'learned'
            idxs = twdb_lookup(mice, 'index', 'grade', 'learnedFirstTask', 1, intmax);
            mice = mice(cell2mat(idxs));
            i = i + 2;
        case 'not-learned'
            idxs = twdb_lookup(mice, 'index', 'key', 'learnedFirstTask', -1);
            mice = mice(cell2mat(idxs));
            i = i + 2;
        otherwise
            error('Invalid input');
    end
    mice = update_idxs(mice);
end
end

function ret = select_or(db, key, vals)
idxs = [];
for i=1:length(vals)
    val = vals(i);
    idxs = [idxs twdb_lookup(db, 'index', 'key', key, val)];
end
ret = db(unique(cell2mat(idxs)));
end

function db = update_idxs(db)
for i=1:length(db)
    db(i).index = i;
end
end