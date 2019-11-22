function [numFrames,skipped_frame_405,skipped_frame_470] = fp_getDroppedFrames(signal_405,signal_470,droppedFrames)

skip_405 = [];
skip_470 = [];
for n = 1:size(signal_470,2)
    z_score_405 = z_score(diff(signal_405(:,n)));
    z_score_470 = z_score(diff(signal_470(:,n)));

    skip_405 = [skip_405 find(abs(z_score_405)>100)];
    skip_470 = [skip_470 find(abs(z_score_470)>100)];
    
end

if ~isempty(skip_405)
    skipped_frame_405 = mean(skip_405);
else
    skipped_frame_405 = skip_405;
end
if ~isempty(skip_470)
    skipped_frame_470 = mean(skip_470);
else
    skipped_frame_470 = skip_470;
end

numFrames = (droppedFrames/max([length(skipped_frame_405),length(skipped_frame_470)])-1)/2;