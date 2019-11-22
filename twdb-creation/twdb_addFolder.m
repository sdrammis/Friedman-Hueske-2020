function twdb = twdb_addFolder(saveFilename,behavioralFilesDir)
%Adds all data from .txt files in a folder
twdb = [];
files = dir(behavioralFilesDir);
for n = 1:length(files)
    file = files(n).name;
    if ~isequal(file,'.') && ~isequal(file,'..') && ~isequal(file,'.DS_Store')
        if ~isequal(file(1:5),'spike')
            twdb = [twdb twdb_add_HD_DB([behavioralFilesDir filesep file])];
        end
    end
end

save(saveFilename,'twdb','-v7.3')