function engagementProportionAcrossTimeGroups(twdb,timeSplit)


miceIDs = get_mouse_ids(twdb,0,'WT','all','all','all','all',1,{});
miceTrials =  get_mouse_trials(twdb,miceIDs,0,0);
WT = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,'',timeSplit);

miceIDs = get_mouse_ids(twdb,0,'HD','all','all','all','all',1,{});
miceTrials =  get_mouse_trials(twdb,miceIDs,0,0);
HD = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,'',timeSplit);


figure
hold on
errorbar(nanmean(WT),std_error(WT))
errorbar(nanmean(HD),std_error(HD))
legend('WT','HD')
xlim([0 timeSplit+1])
xlabel(['Bins of ' num2str((1/timeSplit)*100) '% of trials across time'])
ylabel('Engagement Proportion')
