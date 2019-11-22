%% INIT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% clear all;close all;clc;
% %% PARAMS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% nFibers = 1;
% sessionFolder='C:\Users\Delcasso\Desktop\MIT fp\DataSets\20171108-1521_test02'; % where all the data are
function fp_main(sessionFolder,nFibers)
%clear all;close all;clc;
%% PARAMS ~~~~~~~~~~~~~~x~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%nFibers = 3;
%sessionFolder='H:\11-20-2017_Group4-2705-2740-2833_Session3'; % where all the data are

%% Begining Message
sepColor=[0,0.5,0.25];textColor=[1,0.5,0.25];errorColor=[1,0,0];
cprintf(sepColor,'');
cprintf(sepColor,'#############################################################\n');
cprintf(sepColor,'# \t\t');cprintf(textColor,' Fiber-Photometry Analysis Program');cprintf(sepColor,'\t\t\t#\n');
cprintf(sepColor,'#############################################################\n');

cprintf(sepColor,'\n##### About\n');
cprintf(textColor,'\t\tAuthor : Sebastien Delcasso\n');
cprintf(textColor,'\t\tVersion : 1.5\n');
cprintf(sepColor,'\n##### Parameters\n');
cprintf(textColor,sprintf('\t\tFibers = %d\n',nFibers));
cprintf(textColor,['\t\tsessionFolder = ' strrep(sessionFolder,'\','\\') '\n']);
if ~exist(sessionFolder,'dir')
    cprintf(errorColor,'\t\t!! sessionFolder does not exist !!\n');
end

%% READ THE DATA FROM HAMAMATSU AND EXRACT THE TIMESTAMPS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
listCXD = dir([sessionFolder filesep '*.cxd']); nCXD =size(listCXD,1); 
if nCXD
    cprintf(sepColor,'\n#### Processing  the CXD Video file\n');
    cprintf(textColor,['\t\tvideo file = ' listCXD(1).name '\n']);
    [imageStackValues,imageStackTimestamps]=fp_readCXD([sessionFolder filesep listCXD(1).name]);
else
    cprintf(errorColor,'\t\tVideo File Not Found !\n');
    cprintf(errorColor,'\t\tPlease check the sessionFolder variable and the content of the sessionFolder\n');
end

%% (!! DEPRECATED) AUTOMATIC EXTRACTION OF MULTIPLE SPATIAL FILTERS, ONE FOR EACH FIBER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cprintf(sepColor,'\n#### Extraction of Spatial Filters from template-YYYYMMDD-fiber-X.tif\n');
fiberFilters=fp_extractOneFiberFilterFromOneTemplatePicture(sessionFolder,nFibers);
%% USE OF THE SPATIAL FILTERS TO SPLIT THE SIGNAL FOR EACH FIBER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cprintf(sepColor,'\n#### Applying Spatial Filters to the imageStack\n');
filteredImageStackValues=fp_applyFiberFilters(imageStackValues,fiberFilters);

%% CONTROL IMAGESTACK FOR MISSING FRAMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cprintf(sepColor,'\n#### Correction for missing frames\n');
[filteredImageStackValues,imageStackTimestamps]=fp_correctForMissingFrames(filteredImageStackValues,imageStackTimestamps);

%% DIVIDING SIGNALS INTO PURPLE AND BLUE FRAME SEQUENCES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cprintf(sepColor,'\n#### Splitting Purple (405 nm, ImageStack(1:2:end)) and Blue (470 nm, ImageStack(2:2:end)) and  Signals \n');
purple_imageStackValues=filteredImageStackValues(1:2:end,:);
blue_imageStackValues=filteredImageStackValues(2:2:end,:);
purple_imageStackTimestamps=imageStackTimestamps(1:2:end);
blue_imageStackTimestamps=imageStackTimestamps(2:2:end);

%% LOADING BEHAVIORAL DATA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cprintf(sepColor,'\n#### Loading Behavioral Files \n');
listTxtFile=dir([sessionFolder filesep '*.txt']);
nTxtFile=size(listTxtFile,1);iToRemove=[];
for iTxtFile=1:nTxtFile, if strcmp('fiber-box-table.txt',listTxtFile(iTxtFile).name), iToRemove=iTxtFile;end;end
listTxtFile(iToRemove)=[];nTxtFile=size(listTxtFile,1);
for iTxtFile=1:nTxtFile
     tic;cprintf(textColor,sprintf('\t\tLoading %s ',listTxtFile(iTxtFile).name));
    beh_data{iTxtFile}=load([sessionFolder filesep listTxtFile(iTxtFile).name]);
    beh_filename{iTxtFile}=listTxtFile(iTxtFile).name;
     msg=sprintf(' done in %2.2f sec',toc);
    cprintf(textColor,[msg '\n']);
end

%% ZIPPING AND SAVING ALL DATA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic;cprintf(sepColor,'\n#### Zipping and Saving the data into fpData.mat ');
matFilename=[sessionFolder filesep 'fpData.mat'];
fiberBoxTable = fp_loadFiberBoxTable(sessionFolder);
save(matFilename,'purple_imageStackValues','blue_imageStackValues','purple_imageStackTimestamps','blue_imageStackTimestamps','beh_filename','beh_data','fiberBoxTable','fiberFilters');
msg=sprintf(' done in %2.2f sec',toc);
cprintf(sepColor,[msg '\n']);

%% PLOT DF/F ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cprintf(sepColor,'\n#### Plot global DF/F\n');
fp_plotRawDeltas(sessionFolder);

%% LOADING fpData.mat, Synchronization of Behavioral and Video Data, Zipping and Saving
% Same as behaviora txt file the fiber-photometry data are embedded.
%look for 405 or 470 in the second column respectiveley for purple (control) or blue (GCaMp6, signal) in the generated mat file. fp1.4_mouse_task_session_dateTime_box_fiber.mat file 
cprintf(sepColor,'\n#### Synchronize Behavioral and Video Data\n');
cprintf(textColor,'\t\tGeneration of ''fp1.5_mouse_task_session_dateTime_box_fiber.mat''\n');
fp_synchronizeBehAndPhotTimestamps(sessionFolder);
end
