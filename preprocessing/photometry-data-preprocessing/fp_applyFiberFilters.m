function filteredImageStack=fp_applyFiberFilters(imageStackValues,fiberFilters)
sepColor=[0,0.5,0.25];textColor=[1,0.5,0.25];errorColor=[1,0,0];
[rImg,cImg,imageStackSize]=size(imageStackValues);
nFilters=size(fiberFilters,3);
filteredImageStack=nan(imageStackSize,nFilters);

imageStackSize=size(imageStackValues,3);

for iFilter=1:nFilters
    tic;cprintf(textColor,'\t\tProcessing Fiber (%d/%d, %d Frames)  (blocks of 100 Frames) ',iFilter,nFilters,imageStackSize);
   iBlock=1;
    for i=1:imageStackSize
        if mod(i,100) == 0
            cprintf(textColor,'%d-',iBlock);
            iBlock=iBlock+1;
        end
        tmp=imageStackValues(:,:,i);
        tmp(~fiberFilters(:,:,iFilter))=nan;
        filteredImageStack(i,iFilter)=nanmean(nanmean(tmp));
    end
    msg=sprintf(' done in %2.2f sec',toc);
    cprintf(textColor,[msg '\n']);
end