function experiment = findexp(dbfile, exid)
% Finds the experiment assocaited with an execution ID.
% dbfile - location of pipline JSON database file
% exid - execution ID

% Create a lookup struct of the JSON pipeline database.
jsonDB = jsondecode(fileread(dbfile));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

% Extract exp# for given exid.
experiment = twdb_lookup(imagesMap, 'experiment', 'key', 'exid', exid);
if ~isempty(experiment)
    experiment = experiment{1};
end
end