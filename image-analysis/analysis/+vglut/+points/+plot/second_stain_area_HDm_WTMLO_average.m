COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMLONorm.mat')

%read in first stain data
valsWTMLO = {};
names = areaWTMLO.Properties.VariableNames;
for col = 1:size(areaWTMLO,2)
    if contains(names{col}, '2019')
        valsWTMLO = [valsWTMLO areaWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDm = {};
names = areaHDm.Properties.VariableNames;
for col = 1:size(areaHDm,2)
    if contains(names{col}, '2019')
        valsHDm = [valsHDm areaHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTMLONorm = {};
names = areaWTMLONorm.Properties.VariableNames;
for col = 1:size(areaWTMLONorm,2)
    if contains(names{col}, '2019')
        valsWTMLONorm = [valsWTMLONorm areaWTMLONorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmNorm = {};
names = areaHDmNorm.Properties.VariableNames;
for col = 1:size(areaHDmNorm,2)
    if contains(names{col}, '2019')
        valsHDmNorm = [valsHDmNorm areaHDmNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
valsHDmNormArr = cell2mat(valsHDmNorm)';
valsWTMLONormArr = cell2mat(valsWTMLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
title(['Area HD matrix vs. WT old learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
title(['Normalized Area HD matrix vs. WT old learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


