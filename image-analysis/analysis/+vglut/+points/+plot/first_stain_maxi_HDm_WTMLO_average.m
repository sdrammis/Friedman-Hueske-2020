% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceMaxIntMat.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdMaxIntensityArrM.mat')

%read in first stain data
valsWTMLO = {};
names = maxiWTMLO.Properties.VariableNames;
for col = 1:size(maxiWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO maxiWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMLONorm = cell2mat(valsWTMLO)';
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArr, [1 12]);


valsHDm = {};
names = maxiHDm.Properties.VariableNames;
for col = 1:size(maxiHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm maxiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArr, [1 16]);



% valsWTMLONorm = {};
% names = maxiWTMLONorm.Properties.VariableNames;
% for col = 1:size(maxiWTMLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMLONorm = [valsWTMLONorm maxiWTMLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = maxiHDmNorm.Properties.VariableNames;
% for col = 1:size(maxiHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm maxiHDmNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end

valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMLONormArr = cell2mat(valsWTMLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
title(['Max Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
title(['Normalized Max Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


