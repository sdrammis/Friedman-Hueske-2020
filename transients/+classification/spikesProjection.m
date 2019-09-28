function [scores470Max, scores405Max] = spikesProjection(traces, goldSpikes)
% Given a set of known "gold" spikes. Project unknown spikes
% multidimensional space to the known spikes.
%
% traces: output from getTraces
% goldSpikes: known spike traces with same format as getTraces output
%
% returns array of max scores of the 470 channel and array of corresponding
% score of the 405 channel

spikes470 = [];
spikes405 = [];
for trace=traces
    spikes470 = [spikes470; trace{1}.Trace470'];
    spikes405 = [spikes405; trace{1}.Trace405'];
end

goldSpikes470 = [];
for goldSpike=goldSpikes
    goldSpikes470 = [goldSpikes470; goldSpike{1}.Trace470'];
end

numspikes = size(spikes470, 1);
scores470 = cell2mat(  arrayfun(@(a) arrayfun( @(b) dot(goldSpikes470(a,:), spikes470(b,:)) / norm(goldSpikes470(a,:)), 1:size(spikes470,1)), ...
    (1:size(goldSpikes470,1))', 'UniformOutput', false) )';
scores405 = cell2mat(  arrayfun(@(a) arrayfun( @(b) dot(goldSpikes470(a,:), spikes405(b,:)) / norm(goldSpikes470(a,:)), 1:size(spikes405,1)), ...
    (1:size(goldSpikes470,1))', 'UniformOutput', false) )';

scores470Max = [];
scores405Max = [];
for i=1:size(scores470, 1)
    [maxScore, indexOfMaxScore] = max(scores470(i,:));
    scores470Max = [scores470Max; maxScore];
    scores405Max = [scores405Max; scores405(i, indexOfMaxScore)];
end
end


