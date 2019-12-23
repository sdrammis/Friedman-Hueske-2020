% If you are running python in a virtual environment (eg. pyenv)
% you may need to uncomment the following line: 
%py.sys.setdlopenflags(int32(10)) 

ITTR = 100;
ENG = 1;

scoreWTOld = findbest(weightsWTOld, ENG, ITTR);
scoreWTNL = findbest(weightsWTNL, ENG, ITTR);
scoreHDNL = findbest(weightsHDNL, ENG, ITTR);

t1Arr = nan(1,ITTR);
t2Arr = nan(1,ITTR);
for i=1:ITTR
    [t1Arr(i), t2Arr(i)] = runnet(weightsWTYng,ENG);
end
t1 = mean(t1Arr);
t2 = mean(t2Arr);
F= build_score_fn();
scoreWTYng = (-1 * F(t1, t2) + 100) / 200;

scores = [scoreWTYng, scoreWTOld, scoreWTNL, scoreHDNL];
bar(abs(scores-scoreWTYng));
xticklabels({'WT Yng', 'WT Old', 'WT Not Learn', 'HD Not Learn'});
ylabel('Score - WT Yng Score (best)');
title(['Training Function Scores' newline '(Max Distance is 1)']);
ylim([0 1]);

function score = findbest(ws, eng, ittr)
lb = ws; lb(9:14) = max(ws(9:14)) * 0.8;
ub = ws; ub(9:14) = max(ws(9:14)) * 1.2;
F = build_score_fn();
nvars = length(ws);
opts = optimoptions('ga', 'OutputFcn', @gaoutfun, 'PopulationSize', 300, 'MaxGenerations', 200);
fun = @(x) fitnessfun(x, F);
[net, ~] = ga(fun, nvars, [], [], [], [], lb, ub, [], [], opts);

t1Arr = nan(1,ittr);
t2Arr = nan(1,ittr);
for i=1:ittr
    [t1Arr(i), t2Arr(i)] = runnet(net,eng);
end
t1 = mean(t1Arr);
t2 = mean(t2Arr);
score = (-1 * F(t1, t2) + 100) / 200;
end