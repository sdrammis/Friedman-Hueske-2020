% Load files: light_twdb_2019-08-15.mat, miceType.mat
% Creates the micedb database for image analysis mice.

micedb = miceType;

% DREADD Animals are stored in a separate structure.
% The DREADDType field does not apply to micedb animals
if isfield(micedb, 'DREADDType')
    micedb = rmfield(micedb, 'DREADDType');
end

% Add histology data to mouse database.
micedb = fromhist(micedb, "Histology animal information.xlsx");

% Add experiment info to mouse database.
micedb = fromtwdb(micedb, twdb);

% Add execution IDs from the pipeline database.
micedb = frompipeline(micedb, 'pipeline-db.json');

% Reorder by mouseIDs
[~, I] = sort(cellfun(@str2double,{micedb.ID}));
micedb = micedb(I);
for i=1:length(micedb)
    micedb(i).index = i;
end

save('./micedb.mat', 'micedb', '-v7.3');