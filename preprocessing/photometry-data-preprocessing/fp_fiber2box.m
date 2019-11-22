function box = fp_fiber2box(sessionFolder,fiber)
fiberBoxTable = fp_loadFiberBoxTable(sessionFolder)
ii=find(fiberBoxTable(:,1)==fiber);
box=fiberBoxTable(ii,2);
