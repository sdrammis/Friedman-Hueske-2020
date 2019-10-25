function blobs = getblobs(analysisdb, mouseID)
idxs = strcmp({analysisdb.mouseID}, mouseID) & strcmp({analysisdb.stack}, 'P');

% TODO divide blobs by # PV cells for slice
blobs = [analysisdb(idxs).pvmsnblobs];
end
