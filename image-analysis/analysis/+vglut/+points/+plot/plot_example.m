COLORS = cbrewer('qual', 'Set2', 50);


%read in first stain data
valsHDM = [];
names = areaHDm.Properties.VariableNames;
for col = 1:size(areaHDm,2)
    if contains(names{col}, '2018')
        valsHDM = [valsHDM areaHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

% load('./path/to/areaHDm.mat');\
%reshape data
valsWTMLO = [];
for col = 1:size(areaWTMLO,2)
    
   valsWTMLO = [valsWTMLO areaWTMLO{:,col}']; 
end

%reshape data
animsHDM = {};
for col = 1:size(areaHDm,2)
   animsHDM{end+1} = areaHDm{:,col}'; 
end

%add all animals in a table to an array 
animsWTMLO = {};
for col = 1:size(areaWTMLO,2)
   animsWTMLO{end+1} = areaWTMLO{:,col}'; 
end


%plot multiple mice on same cdf. also for kstests
% figure;
% subplot(1,2,1);
% plot.cdfcont(animsHDM, {'HDM', 'WTMLO'}, COLORS);
% subplot(1,2,2);
% plot.plotbars({valsHDM, valsWTMLO}, {'HDM', 'WTMLO'}, COLORS, 'nodots');

%plot average cdfs
figure;
plot.avgcdf(gca, animsHDM, [1 0 0], []);
hold on;
plot.avgcdf(gca, animsWTMLO, [0 1 0], []);
