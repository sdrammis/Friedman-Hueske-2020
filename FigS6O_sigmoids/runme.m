% If you are running python in a virtual environment (eg. pyenv)
% you may need to uncomment the following line: 
%py.sys.setdlopenflags(int32(10)) 

% Find the network baseline activity.
ws = weightsBase();
ret =  py.run_net.run_noise(ws,1);
baseline = ret{1};

% Search to find best weights for pv1 to learn
F = build_score_fn();
W = -15:0.5:0;
ITTR = 100;
scores = [];
t1s = [];
t2s = [];

for i = 1:length(W)
    net = ws; net(18:20) = W(i);
    activityT1s = nan(1,ITTR);
    activityT2s = nan(1,ITTR);
    for j=1:ITTR
        [activityT1s(j), activityT2s(j)] = runnet(net,1);
    end
    t1 = mean(activityT1s);
    t2 = mean(activityT2s);
    t1s = [t1s t1];
    t2s = [t2s t2];
    scores = [scores F(t1,t2)];
end

wsWTYng = weightsWTYng();
wsWTOld = weightsWTOld();
wsWTNL = weightsWTNL();
wsHDNL = weightsHDNL();

% Plot results
errs = (scores + 100) ./ 200;
figure;
hold on;
plot(W, t1s);
plot(W, t2s);
plot(W, t1s - t2s);
hline(baseline, 'k:', 'Baseline');
vline(mean(wsWTYng(18:20)), 'k', 'WT Yng');
vline(mean(wsWTOld(18:20)), 'k', 'WT Old');
vline(mean(wsWTNL(18:20)), 'k', 'WT NL');
vline(mean(wsHDNL(18:20)), 'k', 'HD NL');
legend('Tone 1', 'Tone 2', 'T1-T2', 'northwest');
xlabel('Network PV Connection Boundaries');
ylabel('Avg MSN Activity (max is 3)');
