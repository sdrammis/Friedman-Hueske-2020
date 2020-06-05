barYData = {0.0767, -0.3059, 0.7526, -0.2874, 0.7531, 0.1592, 0.1971, 0.3297, -0.2213, 0.5609, -0.1082, -0.3555, 0.0926, -0.0309, 0.0626};
yLab = {'R'};
xLab = {'Reward Trace Sum', 'Reward Trace Sum', 'Reward Trace Sum', 'Reward Trace Sum',...
    'Reward Trace Sum', 'Cost Trace Sum', 'Cost Trace Sum', 'Cost Trace Sum', 'Cost Trace Sum',...
    'Cost Trace Sum', 'Reward Trace Sum - Cost Trace Sum', 'Reward Trace Sum - Cost Trace Sum', ...
    'Reward Trace Sum - Cost Trace Sum', 'Reward Trace Sum - Cost Trace Sum', 'Reward Trace Sum - Cost Trace Sum'};
titleStr = 'All Matrix Mice';
barPData = {0.8227, 0.5555, 0.1421, 0.5320, 0.2469, 0.6410, 0.7082, 0.5879, 0.6335, 0.4391, 0.7515, 0.4892, 0.8822, 0.9475, 0.9374};

hold on
plotBar(barYData,yLab,xLab,titleStr, barPData)
hold off