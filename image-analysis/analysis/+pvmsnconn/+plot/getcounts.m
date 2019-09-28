function  counts = getcounts(analysisdb, mouseID)
idxs = strcmp({analysisdb.mouseID}, mouseID) & strcmp({analysisdb.stack}, 'P');
dat = vertcat(analysisdb(idxs).pvcounts);
if isempty(dat)
    counts = [];
    return;
end

counts = sum(dat{:,'call'}) / sum(dat{:,'aall'});
end

