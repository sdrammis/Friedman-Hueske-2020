function correlationsPerGenotypeBars(twdb,statType,engagement,normalized)

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
end

miceIDs =  get_mouse_ids(twdb,0,'WT',1,'Strio','all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);

genotype = {};
for m = 1:length(miceIDs)
    genotype = [genotype first(twdb_lookup(twdb,'genotype','key','mouseID',miceIDs{m}))];
end
mashIdx = cellfun(@(x)isequal(x,'Mash'),genotype);
[mash_reward,mash_cost,mash_area,mash_ages] = correlationsPerGroup(twdb,miceTrials(mashIdx),miceFluorTrials(mashIdx),rewardTones(mashIdx),costTones(mashIdx),miceIDs(mashIdx),'','Strio WT learned',engagement,statType,normalized,'dPrime');
dlxIdx = cellfun(@(x)isequal(x,'Dlx'),genotype);
[dlx_reward,dlx_cost,dlx_area,dlx_ages] = correlationsPerGroup(twdb,miceTrials(dlxIdx),miceFluorTrials(dlxIdx),rewardTones(dlxIdx),costTones(dlxIdx),miceIDs(dlxIdx),'','Strio WT learned',engagement,statType,normalized,'dPrime');

figure('units','normalized','outerposition',[0 0 1 1])

% subplot(3,1,1)
% hold on
% bar([nanmean(mash_reward) nanmean(dlx_reward)],'b')
% errorbar([nanmean(mash_reward) nanmean(dlx_reward)],...
%     [std_error(mash_reward) std_error(dlx_reward)],'.k')
% plot(ones(length(mash_reward)),mash_reward,'ks','MarkerFaceColor','k')
% plot(2*ones(length(dlx_reward)),dlx_reward,'ks','MarkerFaceColor','k')
% set(gca,'XTickLabel',{['Mash1 n=' num2str(length(mash_reward))],['Dlx1 n=' num2str(length(dlx_reward))]},'XTick',1:2)
% ylabel(['dPrime Reward Sum Correlation ' statStr])
% title('Reward')
% 
% subplot(3,1,2)
% hold on
% bar([nanmean(mash_cost) nanmean(dlx_cost)],'r')
% errorbar([nanmean(mash_cost) nanmean(dlx_cost)],...
%     [std_error(mash_cost) std_error(dlx_cost)],'.k')
% plot(ones(length(mash_cost)),mash_cost,'ks','MarkerFaceColor','k')
% plot(2*ones(length(dlx_cost)),dlx_cost,'ks','MarkerFaceColor','k')
% set(gca,'XTickLabel',{['Mash1 n=' num2str(length(mash_cost))],['Dlx1 n=' num2str(length(dlx_cost))]},'XTick',1:2)
% ylabel(['dPrime Reward Cost Correlation ' statStr])
% title('Cost')

% subplot(3,1,3)
hold on
bar([nanmean(mash_area) nanmean(dlx_area)],'g')
errorbar([nanmean(mash_area) nanmean(dlx_area)],...
    [std_error(mash_area) std_error(dlx_area)],'.k')
plot(ones(length(mash_area)),mash_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(dlx_area)),dlx_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{['Mash1 n=' num2str(length(mash_area))],['Dlx1 n=' num2str(length(dlx_area))]},'XTick',1:2)
ylabel(['dPrime Area Correlation ' statStr])
[~,p] = ttest2(mash_area,dlx_area);
supertitle({'Strio WT Learned',['dPrime correlation ' statStr],['p=', num2str(p)]})