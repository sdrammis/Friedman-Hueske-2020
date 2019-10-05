% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTMNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceAreaIntMat.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdAreaArrM.mat')

%read in first stain data
valsWTMNLO = {};
names = areaWTMNLO.Properties.VariableNames;
for col = 1:size(areaWTMNLO,2)
    if contains(names{col}, '2018')
        valsWTMNLO = [valsWTMNLO areaWTMNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMNLONorm = cell2mat(valsWTMNLO)';
valsWTMNLONormArr = (valsWTMNLONorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsWTMNLONormArr, [1000 3]);
valsWTMNLONorm = num2cell(reshapedArr, [1 3]);


valsHDm = {};
names = areaHDm.Properties.VariableNames;
for col = 1:size(areaHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm areaHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArr, [1 16]);


% valsWTMNLONorm = {};
% names = areaWTMNLONorm.Properties.VariableNames;
% for col = 1:size(areaWTMNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMNLONorm = [valsWTMNLONorm areaWTMNLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = areaHDmNorm.Properties.VariableNames;
% for col = 1:size(areaHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm areaHDmNorm{:,col}'];
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
title(['Area HD matrix vs. WT old not learned matrix. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLONorm, [0 1 0], []);
title(['Normalized Area HD matrix vs. WT old not learned matrix. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])


