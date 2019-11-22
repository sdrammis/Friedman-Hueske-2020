function [signal_405,time_405,signal_470,time_470] = fp_addTimeStamps(signal_405,signal_470,droppedFrames)

if droppedFrames
    [numFrames,skipped_frame_405,skipped_frame_470] = fp_getDroppedFrames(signal_405,signal_470,droppedFrames);
    for n = 1:size(signal_405,2)
        [fixed_405(:,n),fixed_470(:,n)] = fp_correctForMissingFramesNoTimestamps(signal_405(:,n),signal_470(:,n),skipped_frame_405,skipped_frame_470,numFrames);
    end
    signal_405 = fixed_405;
    signal_470 = fixed_470;
end

frameTime = 0.06615;

time_405 = [0:(2*frameTime):((size(signal_405,1)-1)*2*frameTime)]';
time_470 = [frameTime:(2*frameTime):(size(signal_470,1)*2*frameTime)]';