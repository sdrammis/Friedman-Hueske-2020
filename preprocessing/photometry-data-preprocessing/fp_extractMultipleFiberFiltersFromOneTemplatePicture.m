% clear all;close all;clc;
% sessionFolder='C:\Users\Delcasso\Desktop\MIT fPhoto\CXDtest';
% nFibers=1;
function fiberFilters=fp_extractMultipleFiberFiltersFromOneTemplatePicture(sessionFolder,nFibers)

fiberFilters=[];

%% Find Template Image
l=dir([sessionFolder filesep 'template*']);
n=size(l,1);
if n ==1
    
    tpl = imread([sessionFolder filesep l(1).name]);
    
    [rImg,cImg]=size(tpl);
    
    f=figure();
    hold on
    imagesc(tpl(:,:,1));
    colorbar
    print(f,[sessionFolder filesep 'scaled-template.png'],'-dpng');
    close(f);
    
    BW=squeeze(tpl(:,:,1))>65500; %here we looked at the template figure and decide to use 3500 as a thrteshold value
    
    [B,L,N,A] = bwboundaries(BW,'noholes');
    
    if N ~= nFibers
        warning('Problem with fiber detection');
        pause(10000);
        exit();
    end
    
    f=figure('Position',[10 10 1200 200]);
    subplot(1,nFibers+2,1)
    hold on
    imshow(tpl);
    subplot(1,nFibers+2,2)
    hold on
    imshow(label2rgb(L, @jet, [.5 .5 .5]))
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    end
    
    fiberFilters=nan(size(BW,1),size(BW,2),nFibers);
    fiberFilters=uint16(fiberFilters);
    for iFiber=1:nFibers
        [iR,iC]=find(L==iFiber);
        fiberFilters(iR,iC,iFiber)=1;
        subplot(1,nFibers+2,iFiber+2)
        hold on
        boundary = B{iFiber};
       fiberFilters(:,:,iFiber) = poly2mask(boundary(:,2), boundary(:,1),size(BW,1),size(BW,2));
       imgTmp=tpl.*fiberFilters(:,:,iFiber);
       imshow(imgTmp);
    end
    
    
    print(f,[sessionFolder filesep 'extracted-filters.png'],'-dpng');
    close(f);
    
else
    warning(sprintf('function found %d template(s) tif image in %s',n,sessionFolder));
    return
end
