COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMLYNorm.mat')

%read in first stain data
valsWTMLY = {};
names = areaWTMLY.Properties.VariableNames;
for col = 1:size(areaWTMLY,2)
    if contains(names{col}, '2019')
        valsWTMLY = [valsWTMLY areaWTMLY{:,col}'];
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

valsWTMLYNorm = {};
names = areaWTMLYNorm.Properties.VariableNames;
for col = 1:size(areaWTMLYNorm,2)
    if contains(names{col}, '2019')
        valsWTMLYNorm = [valsWTMLYNorm areaWTMLYNorm{:,col}'];
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
valsWTMLYArr = cell2mat(valsWTMLY)';
valsHDmNormArr = cell2mat(valsHDmNorm)';
valsWTMLYNormArr = cell2mat(valsWTMLYNorm)';

[h,p] = kstest2(valsHDmArr, valsWTMLYArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMLYNormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLY, [0 1 0], []);
title(['Area HD matrix vs. WT young learned matrix. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLYNorm, [0 1 0], []);
title(['Normalized Area HD matrix vs. WT young learned matrix. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])


