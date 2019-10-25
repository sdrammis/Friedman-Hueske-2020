function tones()
ws = weights.base();
ret =  py.run_net.run_noise(ws,1);
baseline = ret{1};

[t1WTYng, t2WTYng] = tones_(weights.WTYng, baseline);
[t1WTOld, t2WTOld] = tones_(weights.WTOld, baseline);
[t1WTNL, t2WTNL] = tones_(weights.WTNL, baseline);
[t1WTHD, t2WTHD] = tones_(weights.HDNL, baseline);

y = [t1WTYng, t2WTYng, t1WTYng - t2WTYng; ...
     t1WTOld, t2WTOld, t1WTOld - t2WTOld; ...
     t1WTNL, t2WTNL, t1WTNL - t2WTNL; ...
     t1WTHD, t2WTHD, t1WTHD - t2WTHD];

figure;
bar(y);
xticklabels({'WT Yng', 'WT Old', 'WT Not Learn', 'HD Not Learn'});
legend('Tone 1', 'Tone 2', 'Tone 1 - Tone 2')
title('Tone Activity for Animal Groups');
ylabel('Avg Acitivty - Baseline');
end

function [t1, t2] = tones_(ws, baseline)
ITTR = 100;

t1Arr = nan(1,ITTR);
t2Arr = nan(1,ITTR);
for i=1:ITTR
    [t1Arr(i), t2Arr(i)] = runnet(ws,1);
end
t1 = mean(t1Arr) - baseline;
t2 = mean(t2Arr) - baseline;
end