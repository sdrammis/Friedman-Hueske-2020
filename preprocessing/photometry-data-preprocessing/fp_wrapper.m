function fp_wrapper(photometryDir,destinationFolder,savedFolder)

if ~isempty(savedFolder)
    savedFiles = dir(savedFolder);
    savedFilenames = {savedFiles.name};
else
    savedFilenames = {};
end
folders = dir(photometryDir);
for n = 1:length(folders)
    if ~isequal(folders(n).name,'.') && ~isequal(folders(n).name,'..') && ~isequal(folders(n).name,'.DS_Store')
        groupDir = fullfile(photometryDir,folders(n).name);
        fp_fixSessionWrapper(groupDir,destinationFolder,savedFilenames)
    end
end