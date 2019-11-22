% clear all;close all;clc;
% filename='C:\Users\Delcasso\Desktop\MIT fPhoto\CXDtest\Data00001.cxd';

function [imageStackValues,imageStackTimestamps]=fp_readCXD(filename)
[filepath,name,ext] = fileparts(filename) ;
data=fp_bfopen(filename);
imageStack = data{1, 1};
nImages = size(imageStack, 1);
omeMeta = data{1, 4};
image1=imageStack{1,1};
[image_nRows,image_nColumns]=size(image1);
imageStackValues=zeros(image_nRows,image_nColumns,nImages);
imageStackTimestamps=nan(nImages,1);
textColor=[1,0.5,0.25];
tic;cprintf(textColor,'\t\tData extraction (%d Frames) (blocks of 100 Frames)',nImages);
 iBlock=1;
for i=0:nImages-1
    if mod(i,100) == 0
            cprintf(textColor,'%d-',iBlock);
            iBlock=iBlock+1;
    end
    imageStackValues(:,:,i+1)=double(imageStack{i+1,1}); % imagestack indices 1:nFrames
    imageStackTimestamps(i+1)=double(omeMeta.getPlaneDeltaT(0,i).value()); % getPlaneDeltaT indices 0:nFrames-1
end
msg=sprintf(' done in %2.2f sec',toc);
cprintf(textColor,[msg '\n']);
sFreq = 1 / median(diff(imageStackTimestamps));
cprintf(textColor,'\t\tVideo Sampling Rate  = %2.2f Hz\n',sFreq);
% close(h);
f=figure();
imagesc(max(imageStackValues,[],3));
print(f,[filepath filesep 'max-' name '.png'],'-dpng');
close(f);
