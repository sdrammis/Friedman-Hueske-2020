function imgslice= findslice(dbfile, exid)
% Finds the image slice name associated with an execution ID.
% dbfile - location of pipline JSON database file
% exid - execution ID

% Create a lookup struct of the JSON pipeline database.
jsonDB = jsondecode(fileread(dbfile));
imagesMap = jsonDB.executions;
for i=1:size(imagesMap,1)
    imagesMap(i).index = i;
end

% Extract image slice name for given exit.
imgslice = twdb_lookup(imagesMap, 'slice', 'key', 'exid', exid);
if ~isempty(imgslice)
    imgslice = imgslice{1};
end
end