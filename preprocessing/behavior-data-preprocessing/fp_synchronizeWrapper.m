function fp_synchronizeWrapper(dataToSynchronizeFolder,destinationFolder)

files = dir(dataToSynchronizeFolder);
for n = 1:length(files)
    if ~isequal(files(n).name,'.') && ~isequal(files(n).name,'..') && ~isequal(files(n).name,'.DS_Store')
        fileToSync = fullfile(dataToSynchronizeFolder,files(n).name)
       fp_removeBadFibers(fileToSync)
       fp_synchronizeBehAndPhotTimestamps(fileToSync,destinationFolder);
    end
end
    