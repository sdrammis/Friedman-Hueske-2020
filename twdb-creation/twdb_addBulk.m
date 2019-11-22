function twdb_addBulk(sessionDir)
%Adds all data from .txt files in directory with many folders
twdb = [];
folders = dir(sessionDir);
for n = 3:length(folders)
    files = fullfile(sessionDir,folders(n).name);
    twdb = [twdb twdb_addFolder(files)];
end

save('twdb','twdb')