function spikes()
COLORS = [0.45 0.45 0.45; 0 1 0];

[t1NengWTYng, t2NengWTYng, noiseNengWTYng] = spikes_(weights.WTYng, 0);
[t1NengWTOld, t2NengWTOld, noiseNengWTOld] = spikes_(weights.WTOld, 0);

[t1EngWTYng, t2EngWTYng, noiseEngWTYng] = spikes_(weights.WTYng, 1);
[t1EngWTOld, t2EngWTOld, noiseEngWTOld] = spikes_(weights.WTOld, 1);

yMax = max([t1NengWTYng, t1NengWTOld, t2NengWTYng, t2NengWTOld]) + .1;

figure;
subplot(1,2,1);
b = bar([t1NengWTYng t1EngWTYng; ...
         t2NengWTYng t2EngWTYng; ...
         noiseNengWTYng noiseEngWTYng]);
for k = 1:size(b,2)
    b(k).FaceColor = COLORS(k,:);
end
xticklabels({'Tone 1', 'Tone 2', 'Noise'});
ylabel('Avg # Events');
legend({'Not Engaged', 'Engaged'});
ylim([0 yMax]);
title('# Events - WT Young');
subplot(1,2,2);
b = bar([t1NengWTOld t1EngWTOld; ...
         t2NengWTOld t2EngWTOld; ...
         noiseNengWTOld noiseEngWTOld]);
for k = 1:size(b,2)
    b(k).FaceColor = COLORS(k,:);
end
xticklabels({'Tone 1', 'Tone 2', 'Noise'});
ylabel('Avg # Events');
legend({'Not Engaged', 'Engaged'});
ylim([0 yMax]);
title('# Events - WT Old');
end

function [t1NumEvents, t2NumEvents, noiseNumEvents] = spikes_(ws, eng)
ITTR = 100;

t1Arr = nan(1,ITTR);
t2Arr = nan(1,ITTR);
noiseArr = nan(1,ITTR);
for i=1:ITTR 
    [~, ~, t1Arr(i), t2Arr(i)] = runnet(ws, eng);
    noise =  py.run_net.run_noise(py.list(ws), eng);
    noiseArr(i) = noise{2};
end
t1NumEvents = mean(t1Arr);
t2NumEvents = mean(t2Arr);
noiseNumEvents = mean(noiseArr);
end

