function fiberFilters=fp_extractOneFiberFilterFromOneTemplatePicture(sessionFolder,nFibers)
sepColor=[0,0.5,0.25];textColor=[1,0.5,0.25];errorColor=[1,0,0];
templateFormat =  'template-*-fiber-*.tif';
cprintf(textColor,'\t\ttemplateFormat = ''%s''\n',templateFormat);
l=dir([sessionFolder filesep templateFormat]);nFiles=size(l,1);
cprintf(textColor,'\t\tnFiles=%d, %d template file(s) was(were) found\n',nFiles,nFiles);
if nFiles~=nFibers
    cprintf(errorColor,'\t\t nFiles=%d does not match nFiber=%d !!\n',nFiles,nFibers);
    cprintf(errorColor,'\t\tTemplate file(s) is(are) missing, or the filename(s) incorrect !!\n');
    cprintf(errorColor,'\t\tplease check the content of %s\n',sessionFolder);
    cprintf(errorColor,'\t\tThe programe is looking for %d files (because of the variable nFibers at the begning of the fp_main.m function)\n',nFibers);
    cprintf(errorColor,'\t\tThe filename should be following this format : ''template-YYYYMMDD-fiber-X.tif''\n',nFibers);
    cprintf(errorColor,'\t\tfor ex : template-20171103-fiber-1.tif');
    pause();
end

fiberFilters=[];

for iFile=1:nFiles
    filename=[sessionFolder filesep l(iFile).name];
    msg=sprintf('%s',l(iFile).name);
    cprintf(textColor,['\t\t>> ' msg '\n']);
    [date,iFiber]=fp_parseFiberFilter(filename);
    f=figure('Position',[100 100 500 500]);
    subplot(1,2,1)
    hold on
    title('templatePicture')
    tpl = imread(filename);
    [r,c]=size(tpl);
    if iFile==1
        fiberFilters=nan(r,c,nFibers);
        fiberFilters=uint16(fiberFilters);
    end
    imagesc(tpl(:,:,1));
    colorbar;xlim([1 c]);ylim([1 r]);set(gca,'Ydir','reverse')
    subplot(1,2,2)
    hold on
    title('spatialFilter')
    fiberFilters(:,:,iFiber)=squeeze(tpl(:,:,1))>60000; %here we looked at the template figure and decide to use 3500 as a thrteshold value
    imagesc(squeeze(fiberFilters(:,:,iFiber)));
    xlim([1 c]);ylim([1 r]);     set(gca,'Ydir','reverse')
    print(f,[sessionFolder filesep 'extracted-fiberfilter-' num2str(iFiber) '.png'],'-dpng');
    close(f);
end
