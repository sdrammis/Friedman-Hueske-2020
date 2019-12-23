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

hold on
bar([nanmean(youngWTlearned_area) nanmean(oldWTlearned_area)],'b')
errorbar([nanmean(youngWTlearned_area) nanmean(oldWTlearned_area)],...
    [std_error(youngWTlearned_area) std_error(oldWTlearned_area)],'.k')
plot(ones(length(youngWTlearned_area)),youngWTlearned_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_area)),oldWTlearned_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel([xType ' Response Trace Area Correlation ' statStr])
title('Area')



if isequal(xType,'c')
    supertitle({striosomality,['c correlation ' statStr],''})
else 
    supertitle({striosomality,['dPrime correlation ' statStr],''})
end
