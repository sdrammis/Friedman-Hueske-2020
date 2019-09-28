function [grades, group] = gradeSpikes(traces, spikeTimes, goldSpikes, peakIdx)
% Grade extracted spikes as noise or spike and group the spikes by big or
% small
%   (noise, spike) : (0, 1)
%   big: 1, small: 0
% 
% traces: traces output from getTraces
% spikeTimes: times output from getTraces
% goldSpikes: set of known spike traces
% peakIdx: idx of trace where the peak of the spike is
%
% returns an arrays of grades and groups


grades = nan([1, size(traces, 2)]);
group = nan([1, size(traces, 2)]);

%% Compute values for all spikes
lrBetas = classification.spikesLinearRegression(traces, spikeTimes, peakIdx);
[projScores470, projScores405] = classification.spikesProjection(traces, goldSpikes);
areas = classification.spikesArea(traces, spikeTimes, peakIdx);
projScores = projScores470(:,1) - projScores405(:,1);
scores = (projScores470(:,1) - projScores405(:,1)) .* areas'; 
velocities = classification.spikesVelocity(traces, peakIdx);
zscores = [];
for i=1:size(traces,2)
    zscores = [zscores; traces{i}.Trace470(peakIdx)];
end

%% Preliminary grading as good or bad spike
meanBeta = mean(lrBetas);
stdBeta = std(lrBetas);
meanVel = mean(velocities);
stdVel = std(velocities);
scoresCutoff = real(mean(log(scores))) - 2 * std(log(scores));

for i=1:size(grades,2)
    b = lrBetas(i);
    v = velocities(i);
    s = scores(i);
    
    if (b < meanBeta - 2 * stdBeta || b > meanBeta + 2 * stdBeta)
        grades(i) = 0; 
    elseif (v < meanVel - 2 * stdVel)
        grades(i) = 0;
    elseif s < 0 || real(log(s)) < scoresCutoff
        grades(i) = 0;
    else
        grades(i) = 1;
    end
end 

%% Update grading for uncertain spikes near the center
uncertainSpikes = [];
for i=1:size(scores)
    s = scores(i);
    b = lrBetas(i);
    if (s < 750 && s > -750 && b > meanBeta - 2 * stdBeta &&  b < meanBeta + 2 * stdBeta)
         uncertainSpikes = [uncertainSpikes; [s b i]];
    end
end

mS = mean(uncertainSpikes(:,1));
sS = std(uncertainSpikes(:,1));
mB = mean(uncertainSpikes(:,2));
sB = std(uncertainSpikes(:,2));
for i=1:size(uncertainSpikes, 1)
    s = uncertainSpikes(i,1);
    b = uncertainSpikes(i,2);
    gradeIdx = uncertainSpikes(i,3);

    scoreS = s / (mS + 1 * sS);
    scoreB = abs(b / (mB + 1 * sB));
    grade = min(1, (scoreS + (1 - scoreB)) / 2);
    
    if grade < 0
        grades(gradeIdx) = 0;
    elseif grade < 1
        grades(gradeIdx) = grade;
    end
end

%% Set spike as big or large
ZSCORE_CUTOFF = 1.3; % by inspection of graph
for i=1:size(group,2)
    zscore = zscores(i);
    if zscore < ZSCORE_CUTOFF
       group(i) =  0;
    else
       group(i) = 1;
    end
end
end
