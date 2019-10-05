% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceTotalIntMat.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdTotalIntensityArrM.mat')

%read in first stain data
valsWTMLO = {};
names = tiWTMLO.Properties.VariableNames;
for col = 1:size(tiWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO tiWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMLONorm = cell2mat(valsWTMLO)';
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArr, [1 12]);


valsHDm = {};
names = tiHDm.Properties.VariableNames;
for col = 1:size(tiHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm tiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArr, [1 16]);


% valsWTMLONorm = {};
% names = tiWTMLONorm.Properties.VariableNames;
% for col = 1:size(tiWTMLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMLONorm = [valsWTMLONorm tiWTMLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = tiHDmNorm.Properties.VariableNames;
% for col = 1:size(tiHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm tiHDmNorm{:,col}'];
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
title(['Total Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
title(['Normalized Total Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


