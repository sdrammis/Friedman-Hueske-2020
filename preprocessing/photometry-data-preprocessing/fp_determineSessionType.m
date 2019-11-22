function [fileType,dataName,droppedFrames,folder] = fp_determineSessionType(sessionDir)

folders = strsplit(sessionDir,'/');
folder = folders{end};
df_index = regexp(folder,'_[0-9]*df');
if ~isempty(df_index)
    droppedFrames = str2num(folder(df_index+1:end-2));
    folder = folder(1:df_index-1);
else
    droppedFrames = 0;
end
dataName = [];
fileType = [];
if exist(fullfile(sessionDir,[folder,'.mat'])) == 2
    dataName = fullfile(sessionDir,[folder,'.mat']);
elseif exist(fullfile(sessionDir,[folders{end},'.mat'])) == 2
    dataName = fullfile(sessionDir,[folders{end},'.mat']);
elseif exist(fullfile(sessionDir,'fpData.mat')) == 2
    dataName = fullfile(sessionDir,'fpData.mat');
end
if ~isempty(dataName)
    load(dataName)
    if exist('blue') == 1 && exist('purple') == 1
        fileType = 'tif';
    elseif exist('blue_imageStackValues') == 1 && exist('purple_imageStackValues') == 1
        fileType = 'cxd';
    end
end