function f = plotnet(weights)
s = [1 1  2 2  3 3  4 4  1 1 1  2 2 2  4 4 4  8 8 8  9 9 9];
t = [8 9  8 9  8 9  8 9  5 6 7  5 6 7  5 6 7  5 6 7  5 6 7];
names = {'Tone' 'Discr' 'On/Off' 'Noise' 'MSN-1' 'MSN-2' 'MSN-3' 'PV-1' 'PV-2'};
G = digraph(s, t, weights, names);
f = figure;
plot(G, 'Layout', 'layered', 'Direction','down','Sources',[1 2 3, 4], 'EdgeLabel', G.Edges.Weight)
title('Model Trained Network');
end
