%% load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediWTSLO.mat')

% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediHDmNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediWTMLONorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediHDsNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\mediWTSLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\allMiceMedInt.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\stdMedianIntensityArr.mat')

%% Normalization factors
allMiceAreaInt = allMiceMedInt;
stdArr = stdMedianIntensityArr;

%% read in first stain data and prefrom normalization for HDs, HDm, WTs and WTm 
valsWTMLO = {};
names = mediWTMLO.Properties.VariableNames;
for col = 1:size(mediWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO mediWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMLONorm = cell2mat(valsWTMLO)';
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArrWTMLO, [1 12]);


valsHDm = {};
names = mediHDm.Properties.VariableNames;
for col = 1:size(mediHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm mediHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaInt) / stdArr;
reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArrHDm, [1 16]);


valsWTSLO = {};
names = mediWTSLO.Properties.VariableNames;
for col = 1:size(mediWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO mediWTSLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
valsWTSLONorm = num2cell(reshapedArrWTSLO, [1 12]);


valsHDs = {};
names = mediHDs.Properties.VariableNames;
for col = 1:size(mediHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs mediHDs{:,col}'];
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
% names = mediWTSLONorm.Properties.VariableNames;
% for col = 1:size(mediWTSLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSLONorm = [valsWTSLONorm mediWTSLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDsNorm = {};
% names = mediHDsNorm.Properties.VariableNames;
% for col = 1:size(mediHDsNorm,2)
%     if contains(names{col}, '2018')
%         valsHDsNorm = [valsHDsNorm mediHDsNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
%% ALWAYS INCLUDE 
valsHDsArr = cell2mat(valsHDs)';
valsWTSLOArr = cell2mat(valsWTSLO)';
%%
% valsHDsNormArr = cell2mat(valsHDsNorm)';
% valsWTSLONormArr = cell2mat(valsWTSLONorm)';
% 
% 
% valsWTMLONorm = {};
% names = mediWTMLONorm.Properties.VariableNames;
% for col = 1:size(mediWTMLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMLONorm = [valsWTMLONorm mediWTMLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = mediHDmNorm.Properties.VariableNames;
% for col = 1:size(mediHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm mediHDmNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
%% ALWAYS INCLUDE
valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
%%
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMLONormArr = cell2mat(valsWTMLONorm)';


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
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_TableFormat')
% save('reshapedArrHDsmedi.mat','reshapedArrHDs');
% save('reshapedArrHDmmedi.mat','reshapedArrHDm');
% save('reshapedArrWTSLOmedi.mat','reshapedArrWTSLO');
% save('reshapedArrWTMLOmedi.mat','reshapedArrWTMLO');
%% Exports normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\VGluT_Particles_ZscoreAcrossWholePopBetterNorm_concatenatedFormat')
% save('valsHDsNormArrMedi.mat','valsHDsNormArr');
% save('valsHDmNormArrMedi.mat','valsHDmNormArr');
% save('valsWTSLONormArrMedi.mat','valsWTSLONormArr');
% save('valsWTMLONormArrMedi.mat','valsWTMLONormArr');
%% Exports not normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_concatenatedFormat\Raw')
% save('valsHDsArrMedi.mat','valsHDsArr');
% save('valsHDmArrMedi.mat','valsHDmArr');
% save('valsWTSLOArrMedi.mat','valsWTSLOArr');
% save('valsWTMLOArrMedi.mat','valsWTMLOArr');
%% plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
hold on;
plot.avgcdf(gca, valsHDs, [0 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLO, [0 0 1], []);
title('Median intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pHDSvsWTS),'.'));
% xlim([4 25])
ylim([0 1.1])
subplot(1,2,2);
plot1 = plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot2 = plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
hold on;
plot3 = plot.avgcdf(gca, valsHDsNorm, [0 0 0], []);
% plot3.FaceAlpha = .5;
hold on;
plot4 = plot.avgcdf(gca, valsWTSLONorm, [0 0 1], []);
title('Normalized median intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pNormHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pNormWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pNormHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pNormHDSvsWTS),'.'));
ylim([0 1.1])



