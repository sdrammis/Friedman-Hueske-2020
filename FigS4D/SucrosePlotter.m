function SucrosePlotter(twdb)



%cohorts: ?8, 9-12, ?13

%young cohort

WT_depwater = cell2mat(twdb_lookup(twdb, 'DeprivedWater', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_notdepwater = cell2mat(twdb_lookup(twdb, 'NotDeprivedWater', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_depsucrose = cell2mat(twdb_lookup(twdb, 'DeprivedSucrose', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_notdepsucrose = cell2mat(twdb_lookup(twdb, 'NotDeprivedSucrose', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));

HD_depwater = cell2mat(twdb_lookup(twdb, 'DeprivedWater', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_notdepwater = cell2mat(twdb_lookup(twdb, 'NotDeprivedWater', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_depsucrose = cell2mat(twdb_lookup(twdb, 'DeprivedSucrose', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_notdepsucrose = cell2mat(twdb_lookup(twdb, 'NotDeprivedSucrose', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));

ydata = {WT_depwater, WT_depsucrose, HD_depwater, HD_depsucrose, WT_notdepwater, WT_notdepsucrose , ...
     HD_notdepwater, HD_notdepsucrose};
ylabel = 'ml consumed';
xlabel = {'Water Deprived WT', '', 'Water Deprived HD', '', ...
    'Not Water Deprived WT', '', 'Not Water Deprived HD', ''};
title = 'Water and sucrose consumption in WT versus HD mice';
figure();
hold on;
plotBar(ydata, ylabel, xlabel, title)
hold off;

ttest_QZ(WT_depwater, WT_depsucrose, 'Water deprived WT water consumption vs sucrose consumption ');
ttest_QZ(WT_notdepwater, WT_notdepsucrose, 'Not Water Deprived WT water consumption vs sucrose consumption  ');
ttest_QZ(HD_depwater, HD_depsucrose, 'Water Deprived HD water vs sucrose consumption ');
ttest_QZ(HD_notdepwater, HD_notdepsucrose, 'Not Water Deprived HD water vs sucrose consumption ');

