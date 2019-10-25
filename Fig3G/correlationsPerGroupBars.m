function correlationsPerGroupBars(twdb,striosomality,statType,engagement,normalized,xType)

if isequal(statType,'slope')
    if normalized
        statStr = 'abs(slope)';
    else
        statStr = statType;
    end
elseif isequal(statType,'R')
    if normalized
        statStr = 'R^2';
    else
        statStr = statType;
    end
else
    statStr = statType;
end

miceIDs = get_mouse_ids(twdb,0,'WT',1,striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area,youngWTlearned_ages] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'young','Strio WT learned',engagement,statType,normalized,xType);
[oldWTlearned_reward,oldWTlearned_cost,oldWTlearned_area,oldWTlearned_ages] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'old','Strio WT learned',engagement,statType,normalized,xType);

youngWTlearned = [youngWTlearned_ages,youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area];
oldWTlearned = [oldWTlearned_ages,oldWTlearned_reward,oldWTlearned_cost,oldWTlearned_area];


figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,1,1)
hold on
bar([nanmean(youngWTlearned_reward) nanmean(oldWTlearned_reward)],'b')
errorbar([nanmean(youngWTlearned_reward) nanmean(oldWTlearned_reward)],...
    [std_error(youngWTlearned_reward) std_error(oldWTlearned_reward)],'.k')
plot(ones(length(youngWTlearned_reward)),youngWTlearned_reward,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_reward)),oldWTlearned_reward,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel([xType ' Reward Sum Correlation ' statStr])
title('Reward')

subplot(2,1,2)
hold on
bar([nanmean(youngWTlearned_cost) nanmean(oldWTlearned_cost)],'r')
errorbar([nanmean(youngWTlearned_cost) nanmean(oldWTlearned_cost)],...
    [std_error(youngWTlearned_cost) std_error(oldWTlearned_cost)],'.k')
plot(ones(length(youngWTlearned_cost)),youngWTlearned_cost,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_cost)),oldWTlearned_cost,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel([xType ' Cost Sum Correlation ' statStr])
title('Cost')


if isequal(xType,'c')
    supertitle({striosomality,['c correlation ' statStr],''})
else 
    supertitle({striosomality,['dPrime correlation ' statStr],''})
end
