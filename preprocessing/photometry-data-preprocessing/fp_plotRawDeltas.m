function fp_plotRawDeltas(sessionFolder)
% sessionFolder='F:\11-30-2017_Session5_Group4-2791,2833';
matFilename=[sessionFolder filesep 'fpData.mat'];
load(matFilename);

%% PLOT DF/F ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nFibers = size(purple_imageStackValues,2);

for iFiber=1:nFibers
    
    deltaPurple=(purple_imageStackValues(:,iFiber)  - nanmean(purple_imageStackValues(:,iFiber)))./nanmean(purple_imageStackValues(:,iFiber));
    deltaBlue=(blue_imageStackValues(:,iFiber)  - nanmean(blue_imageStackValues(:,iFiber)))./nanmean(blue_imageStackValues(:,iFiber));
    
    f=figure();
    hold on
    plot(purple_imageStackTimestamps,deltaPurple,'m')
    plot(blue_imageStackTimestamps,deltaBlue,'b')
    xlabel('time (s)');
    ylabel('deltaF/F');
    figFilename=[sessionFolder filesep sprintf('fp_fibernum%d',iFiber) '.pdf'];
    print(f,figFilename,'-dpdf');
    figFilename=[sessionFolder filesep sprintf('fp_fibernum%d',iFiber) '.png'];
    print(f,figFilename,'-dpng');
    figFilename=[sessionFolder filesep sprintf('fp_fibernum%d',iFiber) '.fig'];
    savefig(figFilename);
    close(f);
end


