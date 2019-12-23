% If you are running python in a virtual environment (eg. pyenv)
% you may need to uncomment the following line: 
% py.sys.setdlopenflags(int32(10)) 

COLORS = [0.45 0.45 0.45; 0 1 0];
[t1NengWTOld, t2NengWTOld, noiseNengWTOld] = spikes_(weightsWTOld, 0);
[t1EngWTOld, t2EngWTOld, noiseEngWTOld] = spikes_(weightsWTOld, 1);

figure;
b = bar([t1NengWTOld t1EngWTOld; ...
         t2NengWTOld t2EngWTOld; ...
         noiseNengWTOld noiseEngWTOld]);
for k = 1:size(b,2)
    b(k).FaceColor = COLORS(k,:);
end
xticklabels({'Tone 1', 'Tone 2', 'Noise'});
ylabel('Avg # Events');
legend({'Not Engaged', 'Engaged'});
title('# Events - WT Old');


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

