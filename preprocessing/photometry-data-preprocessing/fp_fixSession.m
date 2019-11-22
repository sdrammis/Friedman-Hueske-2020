function fp_fixSession(sessionDir,destinationFolder,savedFilenames)

[sessionType, sessionDataName, droppedFrames] = fp_determineSessionType(sessionDir);

if ~isempty(sessionDataName)
    load(sessionDataName)
    if isequal(sessionType,'tif')
        [purple_imageStackValues,purple_imageStackTimestamps,blue_imageStackValues,...
                blue_imageStackTimestamps] = fp_addTimeStamps(purple,blue,droppedFrames);
        if droppedFrames
            df_index = regexp(sessionDir,'_[0-9]*df');
            newSessionDir = sessionDir(1:df_index-1);
            sessionDir = newSessionDir;
        end
    end
    folders = strsplit(sessionDir,'/');
    matFilename=[destinationFolder filesep folders{end} '_fpData.mat'];
    if exist('fiberBoxTable')
        if sum(fiberBoxTable(:,2)>100)
            fiberBoxTable(fiberBoxTable(:,2)>100,2) = fiberBoxTable(fiberBoxTable(:,2)>100,2)-100;
        end
    elseif ~exist('fiberBoxTable') && exist('beh_filename')
        fiberBoxTable = zeros(length(beh_filename),2);
        for n = 1:length(beh_filename)
            boxN = str2double(beh_filename{n}(end-4));
            fiberBoxTable(n,1) = n;
            fiberBoxTable(n,2) = boxN;
        end
    end
    if ~exist('beh_filename')
        sessionDir
    else
        if ~sum(cellfun(@(x)isequal(x,[folders{end} '_fpData.mat']),savedFilenames))
            save(matFilename,'purple_imageStackValues','blue_imageStackValues',...
                   'purple_imageStackTimestamps','blue_imageStackTimestamps',...
                   'beh_filename','beh_data','fiberBoxTable');
        end
    end
else
    sessionDir
end