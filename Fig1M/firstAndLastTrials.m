function firstAndLastTrials(twdb)

numTrials = 200;
plotType = 'dPrime';
healths = {'WT','WT'};
striosomalities = {'Strio','Matrix'};
photometry = 'all';
exceptions  = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
'2790', '2777', '2736', '2739', '2741', '2743'};

mouseIDs_type1 = get_mouse_ids(twdb,0,healths{1},'all',striosomalities{1},'all','all',photometry,exceptions);
[miceTrials_type1,miceFluorTrials_type1,rewardTones_type1,costTones_type1] = get_all_trials(twdb,mouseIDs_type1,1,0);
[firstTrials_type1,lastTrials_type1] = firstAndLastTrials_perMouse(numTrials,miceTrials_type1,miceFluorTrials_type1,rewardTones_type1,costTones_type1,plotType);

mouseIDs_type2 = get_mouse_ids(twdb,0,healths{2},'all',striosomalities{2},'all','all',photometry,exceptions);
[miceTrials_type2,miceFluorTrials_type2,rewardTones_type2,costTones_type2] = get_all_trials(twdb,mouseIDs_type2,1,0);
[firstTrials_type2,lastTrials_type2] = firstAndLastTrials_perMouse(numTrials,miceTrials_type2,miceFluorTrials_type2,rewardTones_type2,costTones_type2,plotType);

xTit_type1 = [healths{1} ' ' striosomalities{1}];
xTit_type2 = [healths{2} ' ' striosomalities{2}];

figure
subplot(1,2,1)
hold on
bar(1,nanmean(firstTrials_type1))
bar(2,nanmean(lastTrials_type1))
errorbar([1 2],[nanmean(firstTrials_type1) nanmean(lastTrials_type1)],[std_error(firstTrials_type1) std_error(lastTrials_type1)],'k.')
ylabel(plotType)
set(gca,'XTickLabel',{['First ' num2str(numTrials) ' Trials'],['Last ' num2str(numTrials) ' Trials']},'XTick',1:2);
xtickangle(45)
ylim([0 1])
title(xTit_type1)

subplot(1,2,2)
hold on
bar(1,nanmean(firstTrials_type2))
bar(2,nanmean(lastTrials_type2))
errorbar([1 2],[nanmean(firstTrials_type2) nanmean(lastTrials_type2)],[std_error(firstTrials_type2) std_error(lastTrials_type2)],'k.')
ylabel(plotType)
set(gca,'XTickLabel',{['First ' num2str(numTrials) ' Trials'],['Last ' num2str(numTrials) ' Trials']},'XTick',1:2);
xtickangle(45)
ylim([0 1])
title(xTit_type2)

