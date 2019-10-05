% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceTotalIntMat.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdTotalIntensityArrM.mat')

%read in first stain data
valsWTMNLO = {};
names = tiWTMNLO.Properties.VariableNames;
for col = 1:size(tiWTMNLO,2)
    if contains(names{col}, '2018')
        valsWTMNLO = [valsWTMNLO tiWTMNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMNLONorm = cell2mat(valsWTMNLO)';
valsWTMNLONormArr = (valsWTMNLONorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsWTMNLONormArr, [1000 3]);
valsWTMNLONorm = num2cell(reshapedArr, [1 3]);


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


% valsWTMNLONorm = {};
% names = tiWTMNLONorm.Properties.VariableNames;
% for col = 1:size(tiWTMNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMNLONorm = [valsWTMNLONorm tiWTMNLONorm{:,col}'];
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
valsWTMNLOArr = cell2mat(valsWTMNLO)';
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMNLONormArr = cell2mat(valsWTMNLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMNLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMNLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLO, [0 1 0], []);
title(['Total Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLONorm, [0 1 0], []);
title(['Normalized Total Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


