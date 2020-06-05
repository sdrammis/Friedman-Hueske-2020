function firstAndLastTrials(twdb)

plotType = 'c';
ageRanges = [0 9 13 Inf];
healths = {'WT','WT'};
striosomalities = {'Strio','Matrix'};
photometry = 'all';
exceptions  = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
'2790', '2777', '2736', '2739', '2741', '2743'};


mouseIDs_type1 = get_mouse_ids(twdb,0,healths{1},'all',striosomalities{1},'all','all',photometry,exceptions);
[miceTrials_type1,miceFluorTrials_type1,rewardTones_type1,costTones_type1,ages_type1] = get_all_trials(twdb,mouseIDs_type1,1,0);
[firstTrials_type1,lastTrials_type1] = firstAndLastTrials_perMouse(ageRanges,miceTrials_type1,miceFluorTrials_type1,rewardTones_type1,costTones_type1,ages_type1,plotType);

mouseIDs_type2 = get_mouse_ids(twdb,0,healths{2},'all',striosomalities{2},'all','all',photometry,exceptions);
[miceTrials_type2,miceFluorTrials_type2,rewardTones_type2,costTones_type2,ages_type2] = get_all_trials(twdb,mouseIDs_type2,1,0);
[firstTrials_type2,lastTrials_type2] = firstAndLastTrials_perMouse(ageRanges,miceTrials_type2,miceFluorTrials_type2,rewardTones_type2,costTones_type2,ages_type2,plotType);

xTit_type1 = [healths{1} ' ' striosomalities{1}];
xTit_type2 = [healths{2} ' ' striosomalities{2}];

xLab_type1 = {['< 9 Months (n=' num2str(length(firstTrials_type1{1})) ')'] ,[' 9-12 Months (n=' num2str(length(firstTrials_type1{2})) ')'] , ['> 12 Months (n=' num2str(length(firstTrials_type1{3})) ')']};
xLab_type2 = {['< 9 Months (n=' num2str(length(firstTrials_type2{1})) ')'] ,[' 9-12 Months (n=' num2str(length(firstTrials_type2{2})) ')'] , ['> 12 Months (n=' num2str(length(firstTrials_type2{3})) ')']};


figure
subplot(1,2,1)
hold on
errorbar([1 2 3],cellfun(@nanmean,firstTrials_type1),cellfun(@nanstd,firstTrials_type1)./sqrt(cellfun(@length,firstTrials_type1)))
errorbar([1 2 3],cellfun(@nanmean,lastTrials_type1),cellfun(@nanstd,lastTrials_type1)./sqrt(cellfun(@length,lastTrials_type1)))
ylabel(plotType)
set(gca,'XTickLabel',xLab_type1,'XTick',1:numel(xLab_type1));
legend('First','Last')
title(xTit_type1)

subplot(1,2,2)
hold on
errorbar([1 2 3],cellfun(@nanmean,firstTrials_type2),cellfun(@nanstd,firstTrials_type2)./sqrt(cellfun(@length,firstTrials_type2)))
errorbar([1 2 3],cellfun(@nanmean,lastTrials_type2),cellfun(@nanstd,lastTrials_type2)./sqrt(cellfun(@length,lastTrials_type2)))
ylabel(plotType)
set(gca,'XTickLabel',xLab_type2,'XTick',1:numel(xLab_type2));
legend('First','Last')
title(xTit_type2)

end

