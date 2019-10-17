function dzpCorrelation(twdb)

%% Graphs for 2 cases of mice whose c decreases in the DZP trial
% Author: QZ
% 06/21/2019
% dzpCaseStudy.m
%% IX. Correlations of some combination of trace area vs. change in c (increase is positive) (07/02-03/2019)
cases = twdb_lookup(twdb,'mouseID','key','injection','Diazepam',...
    'key','Health','WT','key','intendedStriosomality','Strio'); % all cases
cases([2 6]) = []; % only 0.5 mg/kg
[dzp1,dzp2,dzp3] = dzp_table(twdb);

sal_C = zeros(1,length(cases));
dzp_C = zeros(1,length(cases));
dzp_RAS = zeros(1,length(cases)); % reward trace sum (dzp)
sal_RAS = zeros(1,length(cases)); % reward trace sum (sal)

for i = 1:length(cases)
    disp(i);
    msID = cases(i);
    if strcmp(msID,'4367')
        trialTypes = {'Saline Before','Diazepam'};
    else
        trialTypes = {'Saline Before','Diazepam','Saline After'};
    end
    conc = first(twdb_lookup(twdb,'concentration','key','mouseID',msID,...
        'key','injection','Diazepam'));
    if conc == 1
        disp('OOPS')
        thistable = dzp1;
    elseif conc == 0.5
        thistable = dzp2;
    else
        thistable = dzp3;
    end
    threshold = get_DZP_C_Threshold_QZ(conc,msID,thistable);
    [~,~,c,~,~,~,~,~,dzpC,~,~,~] = calcMeanSaline_DZP_QZ(thistable,msID,threshold);
    sal_C(i) = c;
    dzp_C(i) = dzpC;
    salRTS = [];
    for j = 1:length(trialTypes)
        if strcmp(trialTypes{j},'Diazepam')
            [mouseTrials,mouseFluorTrials,rewardTone,costTone,...
                ~] = get_all_trials(twdb,msID,'Diazepam');
            [~,~,rts,~,~,~,~] = get_dprime_traceArea(first(mouseTrials),...
                first(mouseFluorTrials),rewardTone,costTone,threshold);
            dzp_RAS(i) = rts;
        elseif (strcmp(trialTypes{j},'Saline Before'))
            [mouseTrials1,mouseFluorTrials1,rewardTone1,costTone1,...
                ~] = get_all_trials(twdb,msID,'Saline Before');
            [~,~,rts1,~,~,~,~] = get_dprime_traceArea(first(mouseTrials1),...
                first(mouseFluorTrials1),rewardTone1,costTone1,threshold);
            salRTS = [salRTS rts1];
        else % Saline After
            [mouseTrials2,mouseFluorTrials2,rewardTone2,costTone2,...
                ~] = get_all_trials(twdb,msID,'Saline After');
            [~,~,rts2,~,~,~,~] = get_dprime_traceArea(first(mouseTrials2),...
                first(mouseFluorTrials2),rewardTone2,costTone2,threshold);
            salRTS = [salRTS rts2];
        end
    end
    sal_RAS(i) = mean(salRTS);
end
rAS = dzp_RAS - sal_RAS;
deltaC = dzp_C - sal_C;

% mouse 259 has all NaNs for photometry data.
% Plotting
titleStr = 'WT Strio DZP Mice';
xLab1 = 'Change in C (DZP-Saline)';
x1 = deltaC;
figure() % difference
hold on
plotCorr_QZ('Reward Area Sum',xLab1,titleStr,x1,rAS,0,1,1,cases)
hold off
% % table creation
DATATABLE = table(cases',deltaC',rAS','VariableNames',{'mouseIDs','DiffInC','DiffInRTS'});