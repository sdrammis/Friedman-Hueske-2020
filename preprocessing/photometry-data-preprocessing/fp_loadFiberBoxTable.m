function fiberBoxTable = fp_loadFiberBoxTable(sessionFolder)
tableFileName=[sessionFolder filesep 'fiber-box-table.txt'];
l=dir(tableFileName);nFiles=size(l,1);
if nFiles~=1
    fprintf('%s',sessionFolder);pause();
else
    fiberBoxTable = load(tableFileName);
end
