function excsM = dbload(pathdbJSON)
% Creates a struct of the executions from the pipeline database JSON file.

jsonDB = jsondecode(fileread(pathdbJSON));
excsM = jsonDB.executions;
for i=1:size(excsM,1)
    excsM(i).index = i;
end
end

