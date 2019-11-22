function [fixed_405,fixed_470] = fp_correctForMissingFramesNoTimestamps(signal_405,signal_470,skipped_frame_405,skipped_frame_470,numFrames)

if isempty(skipped_frame_405) && isempty(skipped_frame_470)
%     first 405 frame dropped
    fixed_405 = [nan(numFrames,1);signal_470];
    fixed_470 = [nan(numFrames,1),signal_405];
elseif length(skipped_frame_405) < length(skipped_frame_470)
%     last 470 frame dropped
    fixed_405 = [signal_405; signal_470(end); nan(numFrames,1)];
    fixed_470 = [signal_470(1:end-1); NaN; nan(numFrames,1)];
    skipped_frame_470(end) = [];
elseif length(skipped_frame_470) < length(skipped_frame_405)
%     first 470 frame dropped
    fixed_405 = [nan(numFrames,1);signal_405(1); signal_470];
    fixed_470 = [nan(numFrames,1);NaN;signal_405(2:end)];
    skipped_frame_405(1) = [];
else
    fixed_405 = signal_405;
    fixed_470 = signal_470;
end

while ~isempty(skipped_frame_405) && ~isempty(skipped_frame_470)
    if skipped_frame_405(1) > skipped_frame_470(1)
        %missing 470 frame
        passing_405 = [fixed_405(1:skipped_frame_405(1)); nan(numFrames,1); fixed_470(skipped_frame_470(1)+1:end)];
        passing_470 = [fixed_470(1:skipped_frame_470(1)); NaN; nan(numFrames,1); fixed_405(skipped_frame_405(1)+1:end)];
        
    else
        %missing 405 frame
        passing_405 = [fixed_405(1:skipped_frame_405(1)); NaN; nan(numFrames,1); fixed_470(skipped_frame_470(1)+1:end)];
        passing_470 = [fixed_470(1:skipped_frame_470(1)); nan(numFrames,1); fixed_405(skipped_frame_405(1)+1:end)];
    end
    fixed_405 = passing_405;
    fixed_470 = passing_470;
    
    z_score_405 = z_score(diff(fixed_405));
    z_score_470 = z_score(diff(fixed_470));
    skipped_frame_405 = find(abs(z_score_405)>20);
    skipped_frame_470 = find(abs(z_score_470)>20);
end