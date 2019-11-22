function fp_fixSessionWrapper(groupDir,destinationFolder,savedFilenames)

folders = dir(groupDir);
for n = 1:length(folders)
    if ~isequal(folders(n).name,'.') && ~isequal(folders(n).name,'..') && ~isequal(folders(n).name,'.DS_Store')
        sessionDir = fullfile(groupDir,folders(n).name);
        fp_fixSession(sessionDir,destinationFolder,savedFilenames)
    end
end