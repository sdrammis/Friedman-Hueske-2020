function fp_resynchronizeTimestamps(sessionFolder)

% clear all;close all; clc
% sessionFolder='F:\12-1-2017_Session6_Group3';

sepColor=[0,0.5,0.25];textColor=[1,0.5,0.25];errorColor=[1,0,0];textColor2=[0.65,0.5,0.25];

cprintf(textColor,'\t\tLoad Behavioral Data and Filenames\n');
[beh]=fp_loadBehFromFpData(sessionFolder);
nBeh=size(beh.name,2);
cprintf(textColor,'\t\tLoad fiberBoxTable\n');
fiberBoxTable=fp_loadFiberTableFromFpData(sessionFolder);

for iBeh=1:nBeh
    
    cprintf(textColor,'\t\tProcessing %s\n',beh.name{iBeh});
    cprintf(textColor,'\t\t\tBehavior :: Parse Filename\n');
    [mouse,task,session,dateTime,iBox]=fp_parseBehavioralFilename(beh.name{iBeh});
    ii=find(fiberBoxTable(:,2)==iBox);iFiber=fiberBoxTable(ii,1);
    idxFiber = fp_getFiberIdx(sessionFolder,iFiber);
    cprintf(textColor,'\t\t\tAccording to ''fiber-box-table.txt'' Fiber #%d is associated with Behavior Box #%d\n',iFiber,iBox);
    cprintf(textColor2,'\t\t\tVideo ::  Reconstruct Original Frame Sequence\n');
    [vVideo,tVideo_sec]=fp_reconstructFrameSequence(sessionFolder,idxFiber);
    medTimeBetweenFrames = median(diff(tVideo_sec));
    %we send one interrupt signal each 200 Frames);
    timeBetweenInterrupts_sec = medTimeBetweenFrames * 200;
    cprintf(textColor2,'\t\t\tVideo ::  Estimated Time Between 2 interrupts = %2.2f sec\n',timeBetweenInterrupts_sec);
    bData=beh.data{iBeh};
    cprintf(textColor,'\t\t\tBehavior :: Load Interrupts Timestamps\n');
    iInterrupt=find(bData(:,2)==103);
    nInterrupt=size(iInterrupt,1);
    tInterrupt_sec=bData(iInterrupt,1)/1000;
    dt_Interrupt = diff(tInterrupt_sec);
    iMissingInterrupts=find(dt_Interrupt > (timeBetweenInterrupts_sec*1.5));
    nMissingInterupts = length(iMissingInterrupts);
    cprintf(textColor,'\t\t\tBehavior :: %d missing interrupts were found\n',nMissingInterupts);
    for iMiss=1:nMissingInterupts
        i=iMissingInterrupts(iMiss);
        iMissingInterrupts=iMissingInterrupts+1;
        tInterrupt_sec=[tInterrupt_sec(1:i); mean(tInterrupt_sec(i:i+1)); tInterrupt_sec(i+1:end)];
    end
    nInterrupt=size(tInterrupt_sec,1);
    dt_Interrupt = diff(tInterrupt_sec);
%     plot(dt_Interrupt+1,'g+');
    
    cprintf(textColor,'\t\t\tBehavior :: %d missing interrupts were reinserted\n',nMissingInterupts);
    %     newFrameNumber = (nInterrupt-1)*200;
    %     cprintf(textColor2,'\t\t\tVideo ::  reduction de la video %d a %d ((nInterrupts-1)*200)\n',size(vVideo,2),newFrameNumber);
    
    
    
    
    f=figure();
    subplot(3,1,1)
    hold on
    title('Interrupts')
    
    plot(tInterrupt_sec,ones(nInterrupt,1),'xr')
    t200_sec=tVideo_sec(1:200:end)';
    n200=size(t200_sec,1);
    plot(t200_sec,ones(n200,1),'ob');
    legend({'beh','cam'})
    hold on
    subplot(3,1,2)
    title('Lag')
    %Here we try to realgin for the first time the fp_video and the
    %arduino_behavior. Behavior can stop before video, so if this is the
    %case video needs to be cut before reinterpolation of video_ts based on
    %behavior_ts
    if n200>nInterrupt
        n200=nInterrupt;
        t200_sec=t200_sec(1:n200);
        cprintf(errorColor,'\t\t\tBehavior :: fp video has been shortened to match behavior duration\n',nMissingInterupts);
    end
    plot((t200_sec-tInterrupt_sec)*1000);
    xlabel('# Samples')
    ylabel('Lag (ms)')
    
    subplot(3,1,3)
    hold on
    title('tVideoRealigned')
    % vq = interp1(x,v,xq)
    % vq : corrected_tVideo
    % x  :  interupts_sequence
    % v :  interrupts_timestamps
    % xq : video_sequence
    
    x = 1:nInterrupt; 
    x=x-1; 
    x=x*200; %(one interrupt each 200 Franes);
    x=x+1;
    nFrames=((nInterrupt-1)*200)+1;
    vVideo=vVideo(1:nFrames);
    tVideo_sec=tVideo_sec(1:nFrames);
    corrected_tVideo_sec = interp1(x,tInterrupt_sec,1:nFrames);
    plot(tVideo_sec,vVideo,'k');
    plot(corrected_tVideo_sec,vVideo,'g');
    ylabel('AvgPixelValue');xlabel('Time(s)');legend({'raw ts', 'correctged ts'});
    
    cprintf(textColor,'\t\t\t ''video_ts_realignement.png'' saved\n');
    print(f,[sessionFolder filesep  'video_ts_realignement.png'],'-dpng');
    close(f);
    
    
    ii=isnan(corrected_tVideo_sec);
    corrected_tVideo_sec(ii)=[];
    vVideo(ii)=[];
    corrected_tVideo_sec=corrected_tVideo_sec';
    corrected_tVideo_msec=corrected_tVideo_sec * 1000;
    vVideo=vVideo';
    waveLength(1:2:size(vVideo,1),1)=405;
    waveLength(2:2:size(vVideo,1),1)=470;
    
    fp_data = [corrected_tVideo_msec waveLength vVideo];
    clear corrected_tVideo_msec waveLength vVideo
    fp_data=[bData;fp_data];
    [~,newIdx]=sort(fp_data(:,1));
    fp_data=fp_data(newIdx,:);
    
    
    matFilename=sprintf('fp1.5_%s_%s_%02d_%s_box%d_fiber%d.mat',mouse,task,session,dateTime,iBox,iFiber);
    save([sessionFolder filesep matFilename],'fp_data');
    clear fp_data
    cprintf(textColor,'\t\t\t ''%s'' saved\n',matFilename);
    
end
