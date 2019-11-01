function DeltaSucrosePlot(twdb)

%Kaden DiMarco 6/12/19




WT_depwater = cell2mat(twdb_lookup(twdb, 'DeprivedWater', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_notdepwater = cell2mat(twdb_lookup(twdb, 'NotDeprivedWater', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_depsucrose = cell2mat(twdb_lookup(twdb, 'DeprivedSucrose', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));
WT_notdepsucrose = cell2mat(twdb_lookup(twdb, 'NotDeprivedSucrose', 'key', 'Health', 'WT', 'key', 'RanSucPref', 'Yes'));

HD_depwater = cell2mat(twdb_lookup(twdb, 'DeprivedWater', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_notdepwater = cell2mat(twdb_lookup(twdb, 'NotDeprivedWater', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_depsucrose = cell2mat(twdb_lookup(twdb, 'DeprivedSucrose', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));
HD_notdepsucrose = cell2mat(twdb_lookup(twdb, 'NotDeprivedSucrose', 'key', 'Health', 'HD', 'key', 'RanSucPref', 'Yes'));


DeltaWTDeprived = WT_depsucrose - WT_depwater;

DeltaWTNotDeprived = WT_notdepsucrose - WT_notdepwater;

DeltaHDDeprived = HD_depsucrose - HD_depwater;

DeltaHDNotDeprived = HD_notdepsucrose - HD_notdepwater;


%plotting


ydata = {DeltaWTNotDeprived, DeltaHDNotDeprived, DeltaWTDeprived, DeltaHDDeprived};
ylabel = 'ml (sucrose - water)';
xlabel = {'WT Not Deprived','HD Not Deprived', 'WT Deprived', 'HD Deprived'};
title = 'The Difference Between Sucrose and Water Consumption in Deprived and Non-deprived Mice';
figure();
hold on;
plotBar(ydata, ylabel, xlabel, title)
hold off;

ttest2_QZ(DeltaWTNotDeprived, DeltaHDNotDeprived, 'Non-deprived WT vs HD ');
ttest2_QZ(DeltaWTDeprived, DeltaHDDeprived, 'Deprived WT vs HD ');


