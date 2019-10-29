%% Plot network configurations.
plot.net(weights.WTYng);
title('WT Young');
plot.net(weights.WTOld);
title('WT Old');
plot.net(weights.WTNL);
title('WT Not Learned');
plot.net(weights.HDNL);
title('HD Not Learned');

%% Plot T1, T2, and T1-T2 
plot.tones();

%% Plot scores
plot.scores();

%% Plot # Events
plot.spikes();
