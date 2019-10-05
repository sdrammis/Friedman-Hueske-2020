DATA_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/analysis_output/vglut_kian/output/s'; %raw output of the ImageJ program
OUT_DIR = '//chunky.mit.edu/annex4/afried/resultfiles/analysis_output/vglut_kian/resample';

dirContents = dir(DATA_PATH);
files = {dirContents(:).name};
n_sample = 1000; %length of resample
tI_matrix = [];

%% Initialize tables to save data
% -HDs -- Huntington's Disease Strio
maxiHDs = table();
maxiHDm = table();
tiHDs = table();
tiHDm = table();
meaniHDs = table();
meaniHDm = table();
mediHDs = table();
mediHDm = table();
areaHDs = table();
areaHDm = table();

% -WTSLY -- Wild Type Strio Learned Young
maxiWTSLY = table();
maxiWTMLY = table();
tiWTSLY = table();
tiWTMLY = table();
meaniWTSLY = table();
meaniWTMLY = table();
mediWTSLY = table();
mediWTMLY = table();
areaWTSLY = table();
areaWTMLY = table();    

% -WTSLO -- Wild Type Strio Learned Old
maxiWTSLO = table();
maxiWTMLO = table();
tiWTSLO = table();
tiWTMLO = table();
meaniWTSLO = table();
meaniWTMLO = table();
mediWTSLO = table();
mediWTMLO = table();
areaWTSLO = table();
areaWTMLO = table();  

% -WTSNLO -- Wild Type Strio Not Learned Old
maxiWTSNLO = table();
maxiWTMNLO = table();
tiWTSNLO = table();
tiWTMNLO = table();
meaniWTSNLO = table();
meaniWTMNLO = table();
mediWTSNLO = table();
mediWTMNLO = table();
areaWTSNLO = table();
areaWTMNLO = table();      

% -HDs -- Huntington's Disease Strio Normalized    
maxiHDsNorm = table();
maxiHDmNorm = table();
tiHDsNorm = table();
tiHDmNorm = table();
meaniHDsNorm = table();
meaniHDmNorm = table();
mediHDsNorm = table();
mediHDmNorm = table();
areaHDsNorm = table();
areaHDmNorm = table();

% -WTSLY -- Wild Type Strio Learned Young Normalized
maxiWTSLYNorm = table();
maxiWTMLYNorm = table();
tiWTSLYNorm = table();
tiWTMLYNorm = table();
meaniWTSLYNorm = table();
meaniWTMLYNorm = table();
mediWTSLYNorm = table();
mediWTMLYNorm = table();
areaWTSLYNorm = table();
areaWTMLYNorm = table();    

% -WTSLO -- Wild Type Strio Learned Old Normalized
maxiWTSLONorm = table();
maxiWTMLONorm = table();
tiWTSLONorm = table();
tiWTMLONorm = table();
meaniWTSLONorm = table();
meaniWTMLONorm = table();
mediWTSLONorm = table();
mediWTMLONorm = table();
areaWTSLONorm = table();
areaWTMLONorm = table();  

% -WTSNLO -- Wild Type Strio Not Learned Old Normalized
maxiWTSNLONorm = table();
maxiWTMNLONorm = table();
tiWTSNLONorm = table();
tiWTMNLONorm = table();
meaniWTSNLONorm = table();
meaniWTMNLONorm = table();
mediWTSNLONorm = table();
mediWTMNLONorm = table();
areaWTSNLONorm = table();
areaWTMNLONorm = table();

mouseIDList = {};

% normalization factor information initalized
avgtotalIntensityArr = [];
avgmeanIntensityArr = [];
avgareaArr = [];
avgmaxIntensityArr = [];
avgmedianIntensityArr = [];

stdtotalIntensityArr = [];
stdmeanIntensityArr = [];
stdareaArr = [];
stdmaxIntensityArr = [];
stdmedianIntensityArr = [];

%% Main for loop used to resample raw data csv files. Normalization can also be caluclated on a per mouse basis. Data is saved within
% the for loop, currently commented to ovoid overwriting. 

for iFile=3:134 %length(files)
    %%   
    cd('C:/Users/Alexander/sabrina-workspace/striomatrix-cv/analysis')
    filename = files{iFile};
    filepath = [DATA_PATH '/' filename];
    disp(strcat('processing ----', filename, '...'));
    %% If statment to only look at first stain data; year = 2019. second stain; year = 2018.
    %for second stain.
    newStain = strfind(filename, '2019');
    if ~isempty(newStain)
        disp(filename);
        continue
    end  
    %%
    totalArray = readcell(filepath);%% check colums and rows
    totalArray(1,:) = []; %delete first line bc contains only text
    group = totalArray(:,3);
    tI = totalArray(:,5);
    tI = cell2mat(tI);
    %%
    %replace group and health status:
    %0-strio, 1-matrix, 2-unknown
    %HD-1, WT-0
    region_threshes = {'strio', 'matrix', 'unknown'};
    thresh_vals = [0, 1, 2];
    [tf, idx] = ismember(totalArray(:,3), region_threshes);
    totalArray(tf, 3) = num2cell( thresh_vals( idx(tf) ) );
    
    health_threshes = {'HD', 'WT'};
    health_vals = [1, 0];   
    [t, i] = ismember(totalArray(:,9), health_threshes);
    totalArray(t, 9) = num2cell( health_vals( i(t) ) );   
    %%
    %convert cell array to table so sorting can be done
    totalArray = cell2table(totalArray, 'VariableNames', {'maxintensities' 'areas' 'group' ... 
        'meanIntensity' 'totalIntensity' 'medianIntensity' 'areaStrio' 'areaMatrix' 'health' ...
        'firstSessionAge' 'perfusionAge' 'learnedFirstTask' 'learnedReversalTask'});
    
    %% Get names for columns in tables. mouseID should return m_XXXX_sliceY,
    %where XXXX is 2018 or 2019, and Y is the slice number. Becareful to
    %make sure the find_mouseID wasn't edited. I stole the function from
    %Sabrina so she may have reverted it to the orginal version.
    mouseID = vglut.points.compute.find_mouseID(filename);
    learnedStatus = totalArray.learnedFirstTask(2);
    health = totalArray.health(2);
    age = totalArray.firstSessionAge(2);
    if totalArray.learnedReversalTask(2) == 1
        learnedStatus = 1;
    end    
    
    if endsWith(filename, 'slice1.csv')
        slice = '_slice1';
        mouseID = strcat('m_', mouseID, slice);
    end
    if endsWith(filename, 'slice2.csv')
        slice = '_slice2';
        mouseID = strcat('m_', mouseID, slice);
    end
    if endsWith(filename, 'slice3.csv')
        slice = '_slice3';
        mouseID = strcat('m_', mouseID, slice);
    end        
    if endsWith(filename, 'region1.csv')
        slice = '_region1';
        mouseID = strcat('m_', mouseID, slice);
    end  
    if endsWith(filename, 'region2.csv')
        slice = '_region2';
        mouseID = strcat('m_', mouseID, slice);
    end          
    if endsWith(filename, 'region3.csv')
        slice = '_region3';
        mouseID = strcat('m_', mouseID, slice);
    end  
    if endsWith(filename, 'region4.csv')
        slice = '_region4';
        mouseID = strcat('m_', mouseID, slice);
    end  
    
    %may need to unpack mouseID
%     mouseID=mouseID{1}; 
    mouseIDList{end+1} = mouseID;
    
    %% Find indicies in raw data array that correspond to strio or matrix
    %puncta respectively.
    strioInd=[];
    matrixInd=[];
    for indx=1:length(totalArray.group)
        if totalArray.group(indx) == 0
            strioInd= [strioInd indx];
        end
        if totalArray.group(indx) == 1
            matrixInd= [matrixInd indx];
        end 
    end
    
    %% Downsample
    dsFactorS = round(length(strioInd)/(n_sample + n_sample*.1));
    p = length(strioInd);
    q = (n_sample + n_sample*.1);
    usFactorS = round((n_sample + n_sample*.1)/length(strioInd));
    
    %Catch to make sure files w less than 1000 points are not downsampled, and that \
    %more than 1000 points are not smapled
    if length(strioInd) > 1000 
        strio_indx_ds = downsample(strioInd,dsFactorS);
        if length(strio_indx_ds) < 1000
            dsFactorS = dsFactorS - 1;
            strio_indx_ds = downsample(strioInd,dsFactorS);
        end
        strio_indx_ds = strio_indx_ds(1:n_sample);
    else
        continue
    end
    
    dsFactorM = round(length(matrixInd)/(n_sample + n_sample*.1));
    usFactorM = round((n_sample + n_sample*.1)/length(matrixInd));
    
    if length(matrixInd) > 1000
        matrix_indx_ds = downsample(matrixInd,dsFactorM);
        if length(strio_indx_ds) < 1000
            dsFactorS = dsFactorS - 1;
            matrix_indx_ds = downsample(matrixInd,dsFactorM);
        end
        matrix_indx_ds = matrix_indx_ds(1:n_sample);
    else 
        continue
    end
        
    %% Arrays used to build tables with resampled data for each feature.
    totalIntensityDSs = totalArray.totalIntensity(strio_indx_ds);
    meanIntensityDSs = totalArray.meanIntensity(strio_indx_ds);
    areaDSs = totalArray.areas(strio_indx_ds);
    maxIntensityDSs = totalArray.maxintensities(strio_indx_ds);
    medianIntensityDSs = totalArray.medianIntensity(strio_indx_ds);

    totalIntensityDSm = totalArray.totalIntensity(matrix_indx_ds);
    meanIntensityDSm = totalArray.meanIntensity(matrix_indx_ds);
    areaDSm = totalArray.areas(matrix_indx_ds);
    maxIntensityDSm = totalArray.maxintensities(matrix_indx_ds);
    medianIntensityDSm = totalArray.medianIntensity(matrix_indx_ds);  
    
    %% FROM HERE NORMALIZATION STARTS
    %%Concat strio and matrix tables
    totalIntensityDS = cat(1, totalIntensityDSs, totalIntensityDSm);
    meanIntensityDS = cat(1, meanIntensityDSs, meanIntensityDSm);
    areaDS = cat(1, areaDSs, areaDSm);
    maxIntensityDS = cat(1, maxIntensityDSs, maxIntensityDSm);
    medianIntensityDS = cat(1, medianIntensityDSs, medianIntensityDSm);
    
    %% Average and STD info used for global normalization.
    avgtotalIntensityDS = mean(totalIntensityDS);
    avgtotalIntensityArr = [avgtotalIntensityArr; avgtotalIntensityDS];
    avgmeanIntensityDS = mean(meanIntensityDS);
    avgmeanIntensityArr = [avgmeanIntensityArr; avgmeanIntensityDS];
    avgareaDS = mean(areaDS);
    avgareaArr = [avgareaArr; avgareaDS];
    avgmaxIntensityDS = mean(maxIntensityDS);
    avgmaxIntensityArr = [avgmaxIntensityArr; avgmaxIntensityDS];
    avgmedianIntensityDS = mean(medianIntensityDS);
    avgmedianIntensityArr = [avgmedianIntensityArr; avgmedianIntensityDS];
    
    stdtotalIntensityDS = std(totalIntensityDS);
    stdtotalIntensityArr = [stdtotalIntensityArr; stdtotalIntensityDS];
    stdmeanIntensityDS = std(meanIntensityDS);
    stdmeanIntensityArr = [stdmeanIntensityArr; stdmeanIntensityDS];
    stdareaDS = std(areaDS);
    stdareaArr = [stdareaArr; stdareaDS];
    stdmaxIntensityDS = std(maxIntensityDS);
    stdmaxIntensityArr = [stdmaxIntensityArr; stdmaxIntensityDS];
    stdmedianIntensityDS = std(medianIntensityDS);
    stdmedianIntensityArr = [stdmedianIntensityArr; stdmedianIntensityDS];
    
    
    %% Individually normalize every mouse data (for within-section z-scores to allow Strio vs. Matrix within subject comparisons)
    meanTotalIntensityDS = mean(totalIntensityDS);
    stdTotalIntensityDS = std(totalIntensityDS);   
    normTotalIntensityDSs = (totalIntensityDSs - meanTotalIntensityDS) / stdTotalIntensityDS;
    normTotalIntensityDSm = (totalIntensityDSm - meanTotalIntensityDS) / stdTotalIntensityDS;
    
    meanMeanIntensityDS = mean(meanIntensityDS);
    stdMeanIntensityDS = std(meanIntensityDS);   
    normMeanIntensityDSs = (meanIntensityDSs - meanMeanIntensityDS) / stdMeanIntensityDS;
    normMeanIntensityDSm = (meanIntensityDSm - meanMeanIntensityDS) / stdMeanIntensityDS; 
    
    meanAreaDS = mean(areaDS);
    stdAreaDS = std(areaDS);    
    normAreaDSs = (areaDSs - meanAreaDS) / stdAreaDS;
    normAreaDSm = (areaDSm - meanAreaDS) / stdAreaDS;
    
    meanMaxIntensityDS = mean(maxIntensityDS);
    stdMaxIntensityDS = std(maxIntensityDS);    
    normMaxIntensityDSs = (maxIntensityDSs - meanMaxIntensityDS) / stdMaxIntensityDS;
    normMaxIntensityDSm = (maxIntensityDSm - meanMaxIntensityDS) / stdMaxIntensityDS;
    
    meanMedianIntensityDS = mean(medianIntensityDS);
    stdMedianIntensityDS = std(medianIntensityDS);    
    normMedianIntensityDSs = (medianIntensityDSs - meanMedianIntensityDS) / stdMedianIntensityDS;
    normMedianIntensityDSm = (medianIntensityDSm - meanMedianIntensityDS) / stdMedianIntensityDS;
  
    %% Convert to tables for column naming 
    totalIntensityDSs = array2table(totalArray.totalIntensity(strio_indx_ds));
    meanIntensityDSs = array2table(totalArray.meanIntensity(strio_indx_ds));
    areaDSs = array2table(totalArray.areas(strio_indx_ds));
    maxIntensityDSs = array2table(totalArray.maxintensities(strio_indx_ds));
    medianIntensityDSs = array2table(totalArray.medianIntensity(strio_indx_ds));
    totalIntensityDSs.Properties.VariableNames = {mouseID};
    meanIntensityDSs.Properties.VariableNames = {mouseID};
    areaDSs.Properties.VariableNames = {mouseID};
    maxIntensityDSs.Properties.VariableNames = {mouseID};
    medianIntensityDSs.Properties.VariableNames = {mouseID};
    
    totalIntensityDSm = array2table(totalArray.totalIntensity(matrix_indx_ds));
    meanIntensityDSm = array2table(totalArray.meanIntensity(matrix_indx_ds));
    areaDSm = array2table(totalArray.areas(matrix_indx_ds));
    maxIntensityDSm = array2table(totalArray.maxintensities(matrix_indx_ds));
    medianIntensityDSm = array2table(totalArray.medianIntensity(matrix_indx_ds));
    totalIntensityDSm.Properties.VariableNames = {mouseID};
    meanIntensityDSm.Properties.VariableNames = {mouseID};
    areaDSm.Properties.VariableNames = {mouseID};
    maxIntensityDSm.Properties.VariableNames = {mouseID};
    medianIntensityDSm.Properties.VariableNames = {mouseID};
    
    normMaxIntensityDSs = array2table(normMaxIntensityDSs);
    normMaxIntensityDSm = array2table(normMaxIntensityDSm);   
    normMedianIntensityDSs = array2table(normMedianIntensityDSs);
    normMedianIntensityDSm = array2table(normMedianIntensityDSm);   
    normTotalIntensityDSs = array2table(normTotalIntensityDSs);
    normTotalIntensityDSm = array2table(normTotalIntensityDSm);
    normMeanIntensityDSs = array2table(normMeanIntensityDSs);
    normMeanIntensityDSm = array2table(normMeanIntensityDSm);
    normAreaDSs = array2table(normAreaDSs);
    normAreaDSm = array2table(normAreaDSm);

    normMaxIntensityDSs.Properties.VariableNames = {mouseID};
    normMaxIntensityDSm.Properties.VariableNames = {mouseID};
    normMedianIntensityDSs.Properties.VariableNames = {mouseID};
    normMedianIntensityDSm.Properties.VariableNames = {mouseID};
    normTotalIntensityDSs.Properties.VariableNames = {mouseID};
    normTotalIntensityDSm.Properties.VariableNames = {mouseID};
    normMeanIntensityDSs.Properties.VariableNames = {mouseID};
    normMeanIntensityDSm.Properties.VariableNames = {mouseID};
    normAreaDSs.Properties.VariableNames = {mouseID};
    normAreaDSm.Properties.VariableNames = {mouseID};    
    %% Add resampled data expanding tables that will contain information for
    %each feature for all the mice.
    for feature = 1:6
        if feature == 1 %maxIntensities
            if health == 1 %HD
                maxiHDs = [maxiHDs maxIntensityDSs];
                maxiHDm = [maxiHDm maxIntensityDSm];
                maxiHDsNorm = [maxiHDsNorm normMaxIntensityDSs];
                maxiHDmNorm = [maxiHDmNorm normMaxIntensityDSm];
            elseif health == 0 %WT
                if learnedStatus == 0 %not learned
                    %if age > 10 %old
                    maxiWTSNLO = [maxiWTSNLO maxIntensityDSs];
                    maxiWTMNLO = [maxiWTMNLO maxIntensityDSm];
                    maxiWTSNLONorm = [maxiWTSNLONorm normMaxIntensityDSs];
                    maxiWTMNLONorm = [maxiWTMNLONorm normMaxIntensityDSm];                   
                    %end
                elseif learnedStatus == 1 %learned
                    if age > 10 %old
                        maxiWTSLO = [maxiWTSLO maxIntensityDSs];
                        maxiWTMLO = [maxiWTMLO maxIntensityDSm];
                        maxiWTSLONorm = [maxiWTSLONorm normMaxIntensityDSs];
                        maxiWTMLONorm = [maxiWTMLONorm normMaxIntensityDSm]; 
                    elseif age < 10 %young
                        maxiWTSLY = [maxiWTSLY maxIntensityDSs];
                        maxiWTMLY = [maxiWTMLY maxIntensityDSm];
                        maxiWTSLYNorm = [maxiWTSLYNorm normMaxIntensityDSs];
                        maxiWTMLYNorm = [maxiWTMLYNorm normMaxIntensityDSm];           
                    end                    
                end
            end
        end
        if feature == 2 %areas
            if health == 1 %HD
                areaHDs = [areaHDs areaDSs];
                areaHDm = [areaHDm areaDSm];
                areaHDsNorm = [areaHDsNorm normAreaDSs];
                areaHDmNorm = [areaHDmNorm normAreaDSm];                
            end            
            if health == 0 %WT
                if learnedStatus == 0 %not learned
                    if age > 10 %old
                        areaWTSNLO = [areaWTSNLO areaDSs];
                        areaWTMNLO = [areaWTMNLO areaDSm];
                        areaWTSNLONorm = [areaWTSNLONorm normAreaDSs];
                        areaWTMNLONorm = [areaWTMNLONorm normAreaDSm];                      
                    end
                end
                if learnedStatus == 1 %learned
                    if age > 10 %old
                        areaWTSLO = [areaWTSLO areaDSs];
                        areaWTMLO = [areaWTMLO areaDSm];
                        areaWTSLONorm = [areaWTSLONorm normAreaDSs];
                        areaWTMLONorm = [areaWTMLONorm normAreaDSm];                 
                    end
                    if age < 10 %young\
                        areaWTSLY = [areaWTSLY areaDSs];
                        areaWTMLY = [areaWTMLY areaDSm];
                        areaWTSLYNorm = [areaWTSLYNorm normAreaDSs];
                        areaWTMLYNorm = [areaWTMLYNorm normAreaDSm]; 
                    end                    
                end
            end
        end 
        if feature == 4 %meanIntensities
            if health == 1 %HD
                meaniHDs = [meaniHDs meanIntensityDSs];
                meaniHDm = [meaniHDm meanIntensityDSm];
                meaniHDsNorm = [meaniHDsNorm normMeanIntensityDSs];
                meaniHDmNorm = [meaniHDmNorm normMeanIntensityDSm];             
            end
            if health == 0 %WT
                if learnedStatus == 0 %not learned
                    if age > 10 %old
                        meaniWTSNLO = [meaniWTSNLO meanIntensityDSs];
                        meaniWTMNLO = [meaniWTMNLO meanIntensityDSm];
                        meaniWTSNLONorm = [meaniWTSNLONorm normMeanIntensityDSs];
                        meaniWTMNLONorm = [meaniWTMNLONorm normMeanIntensityDSm];
                    end
                end
                if learnedStatus == 1 %learned
                    if age > 10 %old
                        meaniWTSLO = [meaniWTSLO meanIntensityDSs];
                        meaniWTMLO = [meaniWTMLO meanIntensityDSm];
                        meaniWTSLONorm = [meaniWTSLONorm normMeanIntensityDSs];
                        meaniWTMLONorm = [meaniWTMLONorm normMeanIntensityDSm];                            
                    end
                    if age < 10 %young
                        meaniWTSLY = [meaniWTSLY meanIntensityDSs];
                        meaniWTMLY = [meaniWTMLY meanIntensityDSm];
                        meaniWTSLYNorm = [meaniWTSLYNorm normMeanIntensityDSs];
                        meaniWTMLYNorm = [meaniWTMLYNorm normMeanIntensityDSm]; 
                    end                    
                end
            end
        end                
        if feature == 5 %totalIntensities
            if health == 1 %HD
                tiHDs = [tiHDs totalIntensityDSs];
                tiHDm = [tiHDm totalIntensityDSm];
                tiHDsNorm = [tiHDsNorm normTotalIntensityDSs];
                tiHDmNorm = [tiHDmNorm normTotalIntensityDSm];               
            end
            if health == 0 %WT
                if learnedStatus == 0 %not learned
                    if age > 10 %old
                        tiWTSNLO = [tiWTSNLO totalIntensityDSs];
                        tiWTMNLO = [tiWTMNLO totalIntensityDSm];
                        tiWTSNLONorm = [tiWTSNLONorm normTotalIntensityDSs];
                        tiWTMNLONorm = [tiWTMNLONorm normTotalIntensityDSm];                         
                    end
                end
                if learnedStatus == 1 %learned
                    if age > 10 %old
                        tiWTSLO = [tiWTSLO totalIntensityDSs];
                        tiWTMLO = [tiWTMLO totalIntensityDSm];
                        tiWTSLONorm = [tiWTSLONorm normTotalIntensityDSs];
                        tiWTMLONorm = [tiWTMLONorm normTotalIntensityDSm];                         
                    end
                    if age < 10 %young
                        tiWTSLY = [tiWTSLY totalIntensityDSs];
                        tiWTMLY = [tiWTMLY totalIntensityDSm];
                        tiWTSLYNorm = [tiWTSLYNorm normTotalIntensityDSs];
                        tiWTMLYNorm = [tiWTMLYNorm normTotalIntensityDSm];                       
                    end                    
                end
            end
        end
        if feature == 6 %medianIntensities
            if health == 1 %HD
                mediHDs = [mediHDs medianIntensityDSs];
                mediHDm = [mediHDm medianIntensityDSm];
                mediHDsNorm = [mediHDsNorm normMedianIntensityDSs];
                mediHDmNorm = [mediHDmNorm normMedianIntensityDSm];      
            end
            if health == 0 %WT
                if learnedStatus == 0 %not learned
                    if age > 10 %old
                        mediWTSNLO = [mediWTSNLO medianIntensityDSs];
                        mediWTMNLO = [mediWTMNLO medianIntensityDSm];
                        mediWTSNLONorm = [mediWTSNLONorm normMedianIntensityDSs];
                        mediWTMNLONorm = [mediWTMNLONorm normMedianIntensityDSm];
                    end
                end
                if learnedStatus == 1 %learned
                    if age > 10 %old
                        mediWTSLO = [mediWTSLO medianIntensityDSs];
                        mediWTMLO = [mediWTMLO medianIntensityDSm];
                        mediWTSLONorm = [mediWTSLONorm normMedianIntensityDSs];
                        mediWTMLONorm = [mediWTMLONorm normMedianIntensityDSm];                     
                    end
                    if age < 10 %young
                        mediWTSLY = [mediWTSLY medianIntensityDSs];
                        mediWTMLY = [mediWTMLY medianIntensityDSm];
                        mediWTSLYNorm = [mediWTSLYNorm normMedianIntensityDSs];
                        mediWTMLYNorm = [mediWTMLYNorm normMedianIntensityDSm];                               
                    end                    
                end
            end
        end
    end

%% SAVE TABLES
%%CHANGE DIRECTORY TO NOT OVERWRITE
% cd ('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain')
% 
% save('maxiHDs.mat','maxiHDs');
% save('maxiHDm.mat','maxiHDm');
% save('tiHDs.mat','tiHDs');
% save('tiHDm.mat','tiHDm');
% save('meaniHDs.mat','meaniHDs');
% save('meaniHDm.mat','meaniHDm');
% save('mediHDs.mat','mediHDs');
% save('mediHDm.mat','mediHDm');
% save('areaHDs.mat','areaHDs');
% save('areaHDm.mat','areaHDm');
% 
% save('maxiWTSLY.mat','maxiWTSLY');
% save('maxiWTMLY.mat','maxiWTMLY');
% save('tiWTSLY.mat','tiWTSLY');
% save('tiWTMLY.mat','tiWTMLY');
% save('meaniWTSLY.mat','meaniWTSLY');
% save('meaniWTMLY.mat','meaniWTMLY');
% save('mediWTSLY.mat','mediWTSLY');
% save('mediWTMLY.mat','mediWTMLY');
% save('areaWTSLY.mat','areaWTSLY');
% save('areaWTMLY.mat','areaWTMLY');    
% 
% save('maxiWTSLO.mat','maxiWTSLO');
% save('maxiWTMLO.mat','maxiWTMLO');
% save('tiWTSLO.mat','tiWTSLO');
% save('tiWTMLO.mat','tiWTMLO');
% save('meaniWTSLO.mat','meaniWTSLO');
% save('meaniWTMLO.mat','meaniWTMLO');
% save('mediWTSLO.mat','mediWTSLO');
% save('mediWTMLO.mat','mediWTMLO');
% save('areaWTSLO.mat','areaWTSLO');
% save('areaWTMLO.mat','areaWTMLO');  
% 
% save('maxiWTSNLO.mat','maxiWTSNLO');
% save('maxiWTMNLO.mat','maxiWTMNLO');
% save('tiWTSNLO.mat','tiWTSNLO');
% save('tiWTMNLO.mat','tiWTMNLO');
% save('meaniWTSNLO.mat','meaniWTSNLO');
% save('meaniWTMNLO.mat','meaniWTMNLO');
% save('mediWTSNLO.mat','mediWTSNLO');
% save('mediWTMNLO.mat','mediWTMNLO');
% save('areaWTSNLO.mat','areaWTSNLO');
% save('areaWTMNLO.mat','areaWTMNLO');      
%   
% save('maxiHDsNorm.mat','maxiHDsNorm');
% save('maxiHDmNorm.mat','maxiHDmNorm');
% save('tiHDsNorm.mat','tiHDsNorm');
% save('tiHDmNorm.mat','tiHDmNorm');
% save('meaniHDsNorm.mat','meaniHDsNorm');
% save('meaniHDmNorm.mat','meaniHDmNorm');
% save('mediHDsNorm.mat','mediHDsNorm');
% save('mediHDmNorm.mat','mediHDmNorm');
% save('areaHDsNorm.mat','areaHDsNorm');
% save('areaHDmNorm.mat','areaHDmNorm');
% 
% save('maxiWTSLYNorm.mat','maxiWTSLYNorm');
% save('maxiWTMLYNorm.mat','maxiWTMLYNorm');
% save('tiWTSLYNorm.mat','tiWTSLYNorm');
% save('tiWTMLYNorm.mat','tiWTMLYNorm');
% save('meaniWTSLYNorm.mat','meaniWTSLYNorm');
% save('meaniWTMLYNorm.mat','meaniWTMLYNorm');
% save('mediWTSLYNorm.mat','mediWTSLYNorm');
% save('mediWTMLYNorm.mat','mediWTMLYNorm');
% save('areaWTSLYNorm.mat','areaWTSLYNorm');
% save('areaWTMLYNorm.mat','areaWTMLYNorm');    
% 
% save('maxiWTSLONorm.mat','maxiWTSLONorm');
% save('maxiWTMLONorm.mat','maxiWTMLONorm');
% save('tiWTSLONorm.mat','tiWTSLONorm');
% save('tiWTMLONorm.mat','tiWTMLONorm');
% save('meaniWTSLONorm.mat','meaniWTSLONorm');
% save('meaniWTMLONorm.mat','meaniWTMLONorm');
% save('mediWTSLONorm.mat','mediWTSLONorm');
% save('mediWTMLONorm.mat','mediWTMLONorm');
% save('areaWTSLONorm.mat','areaWTSLONorm');
% save('areaWTMLONorm.mat','areaWTMLONorm');  
% 
% save('maxiWTSNLONorm.mat','maxiWTSNLONorm');
% save('maxiWTMNLONorm.mat','maxiWTMNLONorm');
% save('tiWTSNLONorm.mat','tiWTSNLONorm');
% save('tiWTMNLONorm.mat','tiWTMNLONorm');
% save('meaniWTSNLONorm.mat','meaniWTSNLONorm');
% save('meaniWTMNLONorm.mat','meaniWTMNLONorm');
% save('mediWTSNLONorm.mat','mediWTSNLONorm');
% save('mediWTMNLONorm.mat','mediWTMNLONorm');
% save('areaWTSNLONorm.mat','areaWTSNLONorm');
% save('areaWTMNLONorm.mat','areaWTMNLONorm');

%Example Histogram to make sure distrbution of resample is appropriate.
%     slicename = lower(strrep(filename, '_vglut.csv', ''));
%     sname = [OUT_DIR '/' filename];
%     writecell(tI_matrix, sname);
%     tba = table2array(normMedianIntensityDSs);
%     meantI = mean(tba);
%     stdDS = std(tba);
%     stdOruiginal = std(tI);
%     figure
%     histogram(tba, 'Normalization', 'pdf');
%     hold on
%     figure 
%     histogram(tI, 'Normalization', 'pdf');
%     tI_matrix = [];
end

%% Global normalization; means of arrays w means and STDs for each feature.   
allMiceMaxInt = mean(avgmaxIntensityArr);
allMiceTotalInt = mean(avgtotalIntensityArr);
allMiceMeanInt = mean(avgmeanIntensityArr);
allMiceMedInt = mean(avgmedianIntensityArr);
allMiceAreaInt = mean(avgareaArr);

stdTotalIntensityArr = mean(stdtotalIntensityArr);
stdMeanIntensityArr = mean(stdmeanIntensityArr);
stdAreaArr = mean(stdareaArr);
stdMaxIntensityArr = mean(stdmaxIntensityArr);
stdMedianIntensityArr = mean(stdmedianIntensityArr);

%% Save normalization data
save('allMiceMaxInt.mat', 'allMiceMaxInt');
save('allMiceTotalInt.mat', 'allMiceTotalInt');
save('allMiceMeanInt.mat', 'allMiceMeanInt');
save('allMiceMedInt.mat', 'allMiceMedInt');
save('allMiceAreaInt.mat', 'allMiceAreaInt');

save('stdTotalIntensityArr.mat', 'stdTotalIntensityArr');
save('stdMeanIntensityArr.mat', 'stdMeanIntensityArr');
save('stdAreaArr.mat', 'stdAreaArr');
save('stdMaxIntensityArr.mat', 'stdMaxIntensityArr');
save('stdMedianIntensityArr.mat', 'stdMedianIntensityArr');






