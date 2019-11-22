function idxFiber = fp_getFiberIdx(sessionFolder,iFiber)

% clc;clear all;close all
% sessionFolder='C:\Users\Delcasso\Desktop\MIT fp\DataSets\20171108-1521_test02'; % where all the data are
% iFiber=1;
idxFiber=[];
templateFormat =  'template-*-fiber-*.tif';
l=dir([sessionFolder filesep templateFormat]);nFiles=size(l,1);
if nFiles
    for iFile=1:nFiles
        [date,fiberNum]=fp_parseFiberFilter(l(iFile).name);
        if iFiber==fiberNum
            idxFiber=iFile;
        end
    end
end