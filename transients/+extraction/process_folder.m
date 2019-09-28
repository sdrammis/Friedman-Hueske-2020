function process_folder(photFile, savePath)
%  folderPath - path of folder containing fpData.mat
%      blue_imageStackTimestamps
%      blue_imageStackValues
%      purple_imageStackTimestamps
%      purple_imageStackValues
% output:
%      write 1 file per animal: animal_%d.mat
%      file contains 1 variable:
%          spike_info: contains 6 columns per identified spike
%            1: start time of spike
%            2: peak time of spike
%            3: if spike is part of a burst, start time of burst
%   NOTE: FOR THE NEXT FEW COLUMNS, 470 TRACE IS TAKEN 50 FRAMES BEFORE START AND 50 FRAMES AFTER PEAK
%         405 TRACE IS TAKEN STRICTLY IN BETWEEN THE ABOVE TIME PERIODS AND
%         CONTAINS 1 LESS FRAME (SEE BELOW FOR ILLUSTRATION)
%    TIME ---->---->---->---->---->---->---->---->---->---->---->---->
%       470: S-50       S-49      X-48 .....    E+49       E+50
%       405:        X          X             X         X
%
%            4: 470 raw trace
%            5: 470 raw trace (after double-exponential subtraction)
%            6: 470 z-score trace (after double-exponential subtraction)
%            7: 470 z-score trace (after double-exponential subtraction, both filtered and smoothed)
%            8: 405 raw trace
%            9: 405 raw trace (after double-exponential subtraction)
%           10: 405 z-score trace (after double-exponential subtraction)
%           11: 405 z-score trace (after double-exponential subtraction, both filtered and smoothed)
%
%%
 
load(photFile);
 
% make sure that each of the inputs is changed to a column vector
blue_imageStackTimestamps = reshape(blue_imageStackTimestamps,1,numel(blue_imageStackTimestamps));
purple_imageStackTimestamps = reshape(purple_imageStackTimestamps,1,numel(purple_imageStackTimestamps));
 
sfreq = 1/0.132; % frame rate
secToCut = 240; % get rid of this many seconds from beginning
framesToCut = round(secToCut*sfreq)+1;
 
% sometimes recording is too short
if length(blue_imageStackTimestamps) < framesToCut;return;end
 
for ii = 1:size(blue_imageStackValues,2)
    % use linear interpolation for NA values
    blue_imageStackValues(:,ii) = fillmissing(blue_imageStackValues(:,ii),'linear');
    blue_imageStackTimestamps = fillmissing(blue_imageStackTimestamps,'linear');
    purple_imageStackValues(:,ii) = fillmissing(purple_imageStackValues(:,ii),'linear');
    purple_imageStackTimestamps = fillmissing(purple_imageStackTimestamps,'linear');
end
 
% cut the beginning amount of time since decay does not follow double exp
blue_imageStackTimestamps = blue_imageStackTimestamps(framesToCut:end);
blue_imageStackValues = blue_imageStackValues(framesToCut:end,:);
purple_imageStackValues = purple_imageStackValues(framesToCut:end,:);
purple_imageStackTimestamps = purple_imageStackTimestamps(framesToCut:end);
 
% remove the steps in the recordings
blue_imageStackValues=extraction.remove_steps(blue_imageStackValues, 20, 1.5, 8);
purple_imageStackValues=extraction.remove_steps(purple_imageStackValues, 20, 1.5, 8);
 
% for every animal
for ii = 1:size(blue_imageStackValues,2)
    % re-interpolate if necessary
    btrc = fillmissing(blue_imageStackValues(:,ii),'linear');
    bts = fillmissing(blue_imageStackTimestamps,'linear');
    ptrc = fillmissing(purple_imageStackValues(:,ii),'linear');
    pts = fillmissing(purple_imageStackTimestamps,'linear');    
     
    % find all the 470 channel spikes
    [blueSpikeTimeMatrix, blueSpikeTraces] = extraction.get_blue_spike_info(btrc, bts, 1.5);
    % get the trace of 405 channel at all times when there is a spike in 470
    purpleTraceInfo = extraction.get_purple_trace_at_blue_spike_ts(ptrc, pts, blueSpikeTimeMatrix(:,2));
     
    % make the required output struct
    spike_info = cell(size(blueSpikeTimeMatrix,1),2);
    for jj = 1:size(blueSpikeTimeMatrix,1)
        spike_info{jj,1} = blueSpikeTimeMatrix(jj,1);
        spike_info{jj,2} = blueSpikeTimeMatrix(jj,2);
    end
    spike_info = [spike_info blueSpikeTraces purpleTraceInfo];
     
   %To save with behavioral filename
    boxN = fiberBoxTable(ii,2);
    for n=1:length(beh_filename)
        data = strsplit(beh_filename{n},'_');
        if length(data) == 5 && str2double(data{5}(4))==boxN
            saveFile = [savePath filesep 'spikes_' beh_filename{n}(1:end-4) '_fp2.mat'];
            beh_filename(n) = [];
            break;
        end
    end
    save(saveFile,'spike_info');
end
end
