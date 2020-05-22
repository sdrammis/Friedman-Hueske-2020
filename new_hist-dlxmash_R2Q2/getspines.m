function spines = getspines(analysisdb, mouseID, obs)
idxs = strcmp({analysisdb.mouseID}, mouseID) & strcmp({analysisdb.stack}, 'P');

if strcmp(obs, 'region')
    numSpines = [analysisdb(idxs).msnNumSpines];
    dendLen = [analysisdb(idxs).msnDendriteLength];
elseif strcmp(obs, 'slice')
    numSpines = cellfun(@mean, {analysisdb(idxs).msnNumSpines});
    dendLen = cellfun(@mean, {analysisdb(idxs).msnDendriteLength});
elseif strcmp(obs, 'mouse')
    numSpines = mean([analysisdb(idxs).msnNumSpines]);
    dendLen = mean([analysisdb(idxs).msnDendriteLength]);
end 
spines = numSpines ./ dendLen;
spines = spines(~isnan(spines));
end

