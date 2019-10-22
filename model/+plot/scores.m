function scores()
[F, t1, t2] = build_score_fn();

[t1WTYng, t2WTYng, scoreWTYng] = score(F, weights.WTYng);
[t1WTOld, t2WTOld, scoreWTOld] = score(F, weights.WTOld);
[t1WTNL, t2WTNL, scoreWTNL] = score(F, weights.WTNL);
[t1HDNL, t2HDNL, scoreHDNL] = score(F, weights.HDNL);

[X, Y] = meshgrid(t1,t2);
Z = -1*F(X,Y);

figure;

subplot(1,2,1);
hold on;
surf(X,Y,Z-100); % -100 so scatter values display
view(2)
shading interp
scatter(t1WTYng, t2WTYng, 500, '*r');
text(t1WTYng + .05, t2WTYng, 'WT Young', 'color', 'r');
scatter(t1WTOld, t2WTOld, 400, '*k');
text(t1WTOld + .05, t2WTOld, 'WT Old');
scatter(t1WTNL, t2WTNL, 400, '*k');
text(t1WTNL + .05, t2WTNL, 'WT Not Learn');
scatter(t1HDNL, t2HDNL, 400, '*k');
text(t1HDNL + .05, t2HDNL, 'HD Not Learn');
title('Network Locations on Error Function');
xlabel('T1 Avg Activity - Model Units (Z-scored activity)');
ylabel('T2 Avg Activity - Model Units (Z-Scored activity)');
xticks([0 1 2 3])
xticklabels({'0 (-0.36)', '1 (0.24)', '2 (0.84)', '3 (1.44)'})
yticks([0 1 2 3])
yticklabels({'0 (-0.36)', '1 (0.24)', '2 (0.84)', '3 (1.44)'})

subplot(1,2,2);
scores = [scoreWTYng, scoreWTOld, scoreWTNL, scoreHDNL];
bar(abs(scores-scoreWTYng));
xticklabels({'WT Yng', 'WT Old', 'WT Not Learn', 'HD Not Learn'});
ylabel('Score - WT Yng Score (best)');
title(['Training Function Scores' newline '(Max Distance is 1)']);
ylim([0 1]);
end

function [t1, t2, score] = score(F, ws)
ITTR = 100;

t1Arr = nan(1,ITTR);
t2Arr = nan(1,ITTR);
for i=1:ITTR
    [t1Arr(i), t2Arr(i)] = runnet(ws,1);
end
t1 = mean(t1Arr);
t2 = mean(t2Arr);
score = (-1 * F(t1, t2) + 100) / 200;
end
