%% load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiWTSLO.mat')

% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiHDmNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiWTMLONorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiHDsNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\maxiWTSLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\allMiceMaxInt.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\stdMaxIntensityArr.mat')

%% Normalization factors
allMiceAreaInt = allMiceMaxInt;
stdArr = stdMaxIntensityArr;

%% read in first stain data and prefrom normalization for HDs, HDm, WTs and WTm 
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
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArrWTMLO, [1 12]);



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
valsHDmNormArr = (valsHDmNorm - allMiceAreaInt) / stdArr;
reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArrHDm, [1 16]);


valsWTSLO = {};
names = maxiWTSLO.Properties.VariableNames;
for col = 1:size(maxiWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO maxiWTSLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
valsWTSLONorm = num2cell(reshapedArrWTSLO, [1 12]);


valsHDs = {};
names = maxiHDs.Properties.VariableNames;
for col = 1:size(maxiHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs maxiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDs)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaInt) / stdArr;
reshapedArrHDs = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArrHDs, [1 16]);


%% Original method of Normalization. To use this, you must uncomment the load statments at the top as well.

% valsWTSLONorm = {};
% names = maxiWTSLONorm.Properties.VariableNames;
% for col = 1:size(maxiWTSLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSLONorm = [valsWTSLONorm maxiWTSLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDsNorm = {};
% names = maxiHDsNorm.Properties.VariableNames;
% for col = 1:size(maxiHDsNorm,2)
%     if contains(names{col}, '2018')
%         valsHDsNorm = [valsHDsNorm maxiHDsNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
valsHDsArr = cell2mat(valsHDs)';
valsWTSLOArr = cell2mat(valsWTSLO)';
% valsHDsNormArr = cell2mat(valsHDsNorm)';
% valsWTSLONormArr = cell2mat(valsWTSLONorm)';
% 
% 
% 
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
% 
valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMLONormArr = cell2mat(valsWTMLONorm)';
% 
% 
% reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
% reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
% reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
% reshapedArrHDs = reshape(valsHDsNormArr, [1000 16]);

%% KS tests
[hHDSvsWTS,pHDSvsWTS] = kstest2(valsHDsArr, valsWTSLOArr);
[hNormHDSvsWTS,pNormHDSvsWTS] = kstest2(valsHDsNormArr, valsWTSLONormArr);

[hHDMvsWTM,pHDMvsWTM] = kstest2(valsHDmArr, valsWTMLOArr);
[hNormHDMvsWTM,pNormHDMvsWTM] = kstest2(valsHDmNormArr, valsWTMLONormArr);

[hWTSvsWTM,pWTSvsWTM] = kstest2(valsWTSLOArr, valsWTMLOArr);
[hNormWTSvsWTM,pNormWTSvsWTM] = kstest2(valsWTSLONormArr, valsWTMLONormArr);

[hHDSvsHDM,pHDSvsHDM] = kstest2(valsHDsArr, valsHDmArr);
[hNormHDSvsHDM,pNormHDSvsHDM] = kstest2(valsHDsNormArr, valsHDmNormArr);

%% Produces table format data, ie. 1000 resampled data X number of mice
cd('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+plot\new_norm_resample\reshape')
save('reshapedArrHDsMaxi.mat','reshapedArrHDs');
save('reshapedArrHDmMaxi.mat','reshapedArrHDm');
save('reshapedArrWTSLOMaxi.mat','reshapedArrWTSLO');
save('reshapedArrWTMLOMaxi.mat','reshapedArrWTMLO');
%% Exports normalized resampled data in single cloumn format
cd('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+plot\new_norm_resample')
save('valsHDsNormArrTi.mat','valsHDsNormArr');
save('valsHDmNormArrTi.mat','valsHDmNormArr');
save('valsWTSLONormArrTi.mat','valsWTSLONormArr');
save('valsWTMLONormArrTi.mat','valsWTMLONormArr');
%% Exports not normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_concatenatedFormat\Raw')
% save('valsHDsArrMaxi.mat','valsHDsArr');
% save('valsHDmArrMaxi.mat','valsHDmArr');
% save('valsWTSLOArrMaxi.mat','valsWTSLOArr');
% save('valsWTMLOArrMaxi.mat','valsWTMLOArr');
%%

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
hold on;
plot.avgcdf(gca, valsHDs, [0 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLO, [0 0 1], []);
title('Max intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pHDSvsWTS),'.'));
ylim([0 1.1])
subplot(1,2,2);
plot1 = plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot2 = plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
hold on;
plot3 = plot.avgcdf(gca, valsHDsNorm, [0 0 0], []);
hold on;
plot4 = plot.avgcdf(gca, valsWTSLONorm, [0 0 1], []);
title('Normalized max intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pNormHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pNormWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pNormHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pNormHDSvsWTS),'.'));
ylim([0 1.1])



