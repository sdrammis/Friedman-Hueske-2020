function [F, t1, t2, v] = build_score_fn()
t1 = [0 1.5   3     0  1.5    3   0 1.5 3]';
t2 = [0   0   0   1.5  1.5  1.5   3   3 3]'; 
v  = [0  -50 -100  50    0  -50 100  50 0]';
F = scatteredInterpolant(t1, t2, v);
end



