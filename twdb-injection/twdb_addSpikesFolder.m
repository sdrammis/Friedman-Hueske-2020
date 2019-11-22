function twdb_addSpikesFolder(twdb_file,spikesFileDir)
load(twdb_file)
files = dir(spikesFileDir);
for n = 1:length(files)
    file = files(n).name;
    if ~isequal(file,'.') && ~isequal(file,'..') && ~isequal(file,'.DS_Store')
        if isequal(file(1:5),'spike')
            twdb = addSpikes_HD_DB(twdb,[spikesFileDir filesep file]);
        end
    end
end

save(twdb_file,'twdb','-v7.3')
