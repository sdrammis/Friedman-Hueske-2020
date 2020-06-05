function photometryLearning(twdb,health,intendedStriosomality,lickType)

reversal = 0;
miceIDs = get_mouse_ids(twdb,reversal,health,'all',intendedStriosomality,'all','all',1,{});
upToLearned = 0;
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,upToLearned,reversal);
title_str = [intendedStriosomality ' ' health];


learningPeriod = 0.25;
learningBinSize = 10;
highDprime = 2;
lowDprime = [0.01 0.25];
highLick = 0.25;
lowLick = -0.25;

hDhC_reward = [];
hDhC_cost = [];
hDlC_reward = [];
hDlC_cost = [];
lDhC_reward = [];
lDhC_cost = [];
lDlC_reward = [];
lDlC_cost = [];

for m = 1:length(miceIDs)
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    
    trialsEnd = round(height(mouseTrials)*learningPeriod);
    mouseTrials = mouseTrials(1:trialsEnd,:);
    mouseFluorTrials = mouseFluorTrials(1:trialsEnd,:);
    
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    baseline_mean = nanmean(mouseTrials.ResponseLickFrequency);
    baseline_std = nanstd(mouseTrials.ResponseLickFrequency);
    
    bins = fliplr(height(mouseTrials):-learningBinSize:0);
    for b = 1:length(bins)-1
        bin_range = bins(b)+1:bins(b+1);
        [rewardTrials,costTrials,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials(bin_range,:),mouseFluorTrials(bin_range,:),rewardTone,costTone);
        
        rewardLicks = (nanmean(rewardTrials.ResponseLickFrequency)-baseline_mean)/baseline_std;
        costLicks = (nanmean(costTrials.ResponseLickFrequency)-baseline_mean)/baseline_std;
        [~,~,dPrime] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
        rewardTrace = get_dist_stats(rewardFluorTrials);
        costTrace = get_dist_stats(costFluorTrials);
        
        if isequal(lickType,'cost')
            Licks = costLicks;
        elseif isequal(lickType,'reward')
            Licks = rewardLicks;
        end

        if dPrime > highDprime
            if Licks > highLick
                hDhC_reward = [hDhC_reward; rewardTrace];
                hDhC_cost = [hDhC_cost; costTrace];
            elseif Licks < lowLick
                hDlC_reward = [hDlC_reward; rewardTrace];
                hDlC_cost = [hDlC_cost; costTrace];
            end
        elseif and(dPrime <= lowDprime(2),dPrime >= lowDprime(1))
            if Licks > highLick
                lDhC_reward = [lDhC_reward; rewardTrace];
                lDhC_cost = [lDhC_cost; costTrace];
            elseif Licks < lowLick
                lDlC_reward = [lDlC_reward; rewardTrace];
                lDlC_cost = [lDlC_cost; costTrace];
            end
        end
    end
end


plots_reward = {hDhC_reward,hDlC_reward,...
    lDhC_reward,lDlC_reward};
plots_cost = {hDhC_cost,hDlC_cost,...
    lDhC_cost,lDlC_cost};
plot_labels = {['dPrime > ' num2str(highDprime) ', Z-score ' lickType ' Licks > ' num2str(highLick)],...
    ['dPrime > ' num2str(highDprime) ', Z-score ' lickType ' Licks < ' num2str(lowLick)],...
    [num2str(lowDprime(1)) ' <= dPrime <= ' num2str(lowDprime(2)) ', Z-score ' lickType ' Licks > ' num2str(highLick)],...
    [num2str(lowDprime(1)) ' <= dPrime <= ' num2str(lowDprime(2)) ', Z-score ' lickType ' Licks < ' num2str(lowLick)]};
numRows = 2;
numColumns = length(plots_reward)/numRows;
figure('units','normalized','outerposition',[0 0 1 1])
for n = 1:numRows*numColumns
    subplot(numRows,numColumns,n)
    hold on;
    plot(1:98,ones(1,98)*0.5,'k--')
    plot(1:98,ones(1,98)*0,'k--')
    plot(1:98,ones(1,98)*-0.5,'k--')
    plotPhotometryTraces(plots_reward{n},plots_cost{n})
    title(plot_labels{n})
end
supertitle({title_str,['mice = ' num2str(length(miceIDs)) ', First ' num2str(100*learningPeriod) '% of trials'],''})