function correctedBehData = fp_fixInterrupts(timeBetweenInterrupts_sec,behData)

    tInterrupt_original=behData(behData(:,2)==103,1)/1000;
%     if tInterrupt(1)~=0 && tInterrupts(2)<timeBetweenInterrupts_sec
%         align time data
%     end
    
    tInterrupt_noChains = fp_removeInterruptChains(timeBetweenInterrupts_sec,tInterrupt_original);
    tInterrupt_noMissing = fp_addMissingInterrupts(timeBetweenInterrupts_sec,tInterrupt_noChains);
    tInterrupt_noMissaligned = fp_realignInterrupts(tInterrupt_noMissing);
    tInterrupt_fixedEndpoints = fp_fixEndPointInterrupts(tInterrupt_noMissaligned);
    
    correctedBehTime = tInterrupt_fixedEndpoints*1000;
    correctedBehData = behData;
    correctedBehData(behData(:,2)==103,:) = [];
    correctedInterrupts = [correctedBehTime 103*ones(length(correctedBehTime),1) [1:length(correctedBehTime)]'];
    correctedBehData = [correctedBehData; correctedInterrupts];
    [~,I] = sort(correctedBehData(:,1));
    correctedBehData = correctedBehData(I,:);
    
    figure
    subplot(5,1,1)
    plot(diff(tInterrupt_original),'.')
    subplot(5,1,2)
    plot(diff(tInterrupt_noChains),'.')
    subplot(5,1,3)
    plot(diff(tInterrupt_noMissing),'.')
    subplot(5,1,4)
    plot(diff(tInterrupt_noMissaligned),'.')
    subplot(5,1,5)
    plot(diff(tInterrupt_fixedEndpoints),'.')
    close