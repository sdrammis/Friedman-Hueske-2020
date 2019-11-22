function moveConvergedAnimals(inputDir)

files = dir(inputDir);

for f = 1:length(files)
    filename = files(f).name;
    if ~isequal(filename,'.') && ~isequal(filename,'..') && ~isequal(filename,'.DS_Store')
        filenameParts = strsplit(filename,'-');
        if isequal(filenameParts{1},'converged')
            mouseID = filenameParts{2};
            mouseFolderName = [inputDir filesep mouseID];
            if ~isdir(mouseFolderName)
                mkdir(mouseFolderName)
            end
            sourceFile = [inputDir filesep filename];
            movefile(sourceFile,mouseFolderName)
        end
    end
end