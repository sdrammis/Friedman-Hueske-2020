function twdb = twdb_combine(base_twdb,twdb_to_add,savefile_name)
%Combines 2 TWDBs into one
if ~isequal(class(base_twdb),'struct')
    twdb = load(base_twdb);
    base_twdb = twdb.twdb;
else
    base_twdb = base_twdb;
end

if ~isequal(class(twdb_to_add),'struct')
    twdb = load(twdb_to_add);
    twdb_to_add = twdb.twdb;
else
    twdb_to_add = twdb_to_add;
end

if isfield(base_twdb,'index')
    base_twdb = rmfield(base_twdb,'index');
end
if isfield(twdb_to_add,'index')
    twdb_to_add = rmfield(twdb_to_add,'index');
end
if isfield(base_twdb,'trialSpikes')
    base_twdb = rmfield(base_twdb,'trialSpikes');
end
if isfield(twdb_to_add,'trialSpikes')
    twdb_to_add = rmfield(twdb_to_add,'trialSpikes');
end
twdb = [base_twdb twdb_to_add];

for idx = 1:length(twdb)
    twdb(idx).index = idx;
end

twdb = correctSessionNumbers(twdb);

% save(savefile_name,'twdb','-v7.3')