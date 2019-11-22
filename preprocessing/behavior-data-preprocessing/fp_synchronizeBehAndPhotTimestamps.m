function fp_synchronizeBehAndPhotTimestamps(dataFile,destinationFolder)

load(dataFile)

for n = 1:length(beh_data)
    filename = beh_filename{n};
    dreadd = NaN;
    if isequal(lower(filename(end-6:end-4)),'cno') || isequal(lower(filename(end-6:end-4)),'sal')
        dreadd = filename(end-6:end-4);
        filename = filename(1:end-8);
    end
        
    [mouse,task,session,dateTime,boxN]=fp_parseBehavioralFilename(filename);
    if isnan(mouse)
        continue
    elseif isequal(mouse(1),'0')
        mouse = mouse(2:end);
    end
    fiberN=fiberBoxTable(fiberBoxTable(:,2)==boxN,1);
    if fiberN <= size(blue_imageStackValues,2)
        [vVideo,tVideo_sec] = fp_reconstructFrameSequence(blue_imageStackValues,...
            blue_imageStackTimestamps,purple_imageStackValues,purple_imageStackTimestamps,fiberN);

        behData=beh_data{n};
        if isempty(behData)
            continue
        end
        correctedBehData = fp_fixInterrupts(median(diff(tVideo_sec))*200,behData);

        tVideo_msec = tVideo_sec*1000;

        iIntVideo = 1:200:length(tVideo_sec);
        baseVideoInterrupt = tVideo_msec(1);

        iIntBehavior = find(correctedBehData(:,2)==103);
        if correctedBehData(iIntBehavior(1),1) == 0
            baseBehInterrupt = correctedBehData(iIntBehavior(1),1);
        end

        if length(iIntBehavior)>length(iIntVideo)
            overshoot = length(iIntBehavior)-length(iIntVideo)-1;
            correctedBehData(iIntBehavior(end-overshoot:end),:) = [];
            iIntBehavior(end-overshoot:end) = [];
        end

        intLimitingLength = min([length(iIntBehavior) length(iIntVideo)]);

        cumulative_shift = 0;
        for i=2:intLimitingLength
            videoInterruptInterval = (tVideo_msec(iIntVideo(i)))-baseVideoInterrupt;
            behInterruptInterval = correctedBehData(iIntBehavior(i),1)-baseBehInterrupt;
            intervalRatio = behInterruptInterval/videoInterruptInterval;

            correctedTimeInterval = (correctedBehData(iIntBehavior(i-1)+1:iIntBehavior(i),1)-baseBehInterrupt)/intervalRatio;
            originalInterrupt = correctedBehData(iIntBehavior(i));
            correctedBehData(iIntBehavior(i-1)+1:iIntBehavior(i),1) = correctedTimeInterval+correctedBehData(iIntBehavior(i-1));

            correctionShift = correctedBehData(iIntBehavior(i))-originalInterrupt;
            cumulative_shift = cumulative_shift+correctionShift;
            correctedBehData(iIntBehavior(i)+1:end,1) = correctedBehData(iIntBehavior(i)+1:end,1)+correctionShift;

            baseVideoInterrupt = (tVideo_msec(iIntVideo(i)));
            baseBehInterrupt = correctedBehData(iIntBehavior(i),1);
        end

        waveLength(1:2:length(vVideo),1)=405;
        waveLength(2:2:length(vVideo),1)=470;

        fp_data = [tVideo_msec' waveLength vVideo'];
        fp_data=[correctedBehData;fp_data];
        [~,newIdx]=sort(fp_data(:,1));
        fp_data=fp_data(newIdx,:);

        if isnan(dreadd)
            matFilename=sprintf('%s_%s_%02d_%s_box%d_fp2.mat',mouse,task,session,dateTime,boxN);
        else
            matFilename=sprintf('%s_%s_%02d_%s_box%d_%s_fp2.mat',mouse,task,session,dateTime,boxN,dreadd);
        end
        save([destinationFolder filesep matFilename],'fp_data')
    end
end