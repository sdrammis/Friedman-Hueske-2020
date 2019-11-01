function engagementProportionAcrossTimeGroups(twdb,timeSplit)


miceIDs = get_mouse_ids(twdb,0,'WT',1,'all','all','all',1,{});
miceTrials =  get_mouse_trials(twdb,miceIDs,0,0);
WTL = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,'',timeSplit);

miceIDs = get_mouse_ids(twdb,0,'WT',0,'all','all','all',1,{});
miceTrials =  get_mouse_trials(twdb,miceIDs,0,0);
WTNL = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,'',timeSplit);

miceIDs = get_mouse_ids(twdb,0,'HD',0,'all','all','all',1,{});
miceTrials =  get_mouse_trials(twdb,miceIDs,0,0);
HDNL = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,'',timeSplit);


figure
hold on
errorbar(nanmean(WTL),std_error(WTL))
errorbar(nanmean(WTNL),std_error(WTNL))
errorbar(nanmean(HDNL),std_error(HDNL))
legend('WTL','WTNL','HD')
xlim([0 timeSplit+1])
xlabel(['Bins of ' num2str((1/timeSplit)*100) '% of trials across time'])
ylabel('Engagement Proportion')
