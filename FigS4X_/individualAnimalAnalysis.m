function individualAnimalAnalysis(twdb,health,intendedStriosomality,learned,miceIDs)

if learned
    learned_str = 'learned';
else 
    learned_str = 'not_learned';
end
title_str = [intendedStriosomality ' ' health ' ' learned_str];

[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);

for m = 1:length(miceIDs)
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    firstSessionAge = first(twdb_lookup(twdb, 'firstSessionAge', 'key', 'mouseID', miceIDs{m}));
    
    bin_size = round(0.05*height(mouseTrials));
    x_label = ['Rolling window of ',num2str(bin_size),' trials'];
    
    %rolling window with bin
    bin_responseRewardTraceSum = [];
    bin_responseCostTraceSum = [];
    bin_responseLickFrequencyReward = [];
    bin_responseLickFrequencyCost = [];

    for b = 1:height(mouseTrials) - bin_size + 1
        bin_range = b:b+(bin_size-1);
        bin_mouseTrials = mouseTrials(bin_range,:);
        bin_fluorTrials = mouseFluorTrials(bin_range,:);
        [~,~,bin_responseRewardTraceSum(b),bin_responseCostTraceSum(b)] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
        [bin_responseLickFrequencyReward(b),bin_responseLickFrequencyCost(b)] = get_lickFrequency_acceptanceRate(bin_mouseTrials,rewardTone,costTone);
                
    end
    
    figure('units','normalized','outerposition',[0 0 1 1])
   
    subplot(2,1,1);
    hold on
    maxMinArray = [bin_responseLickFrequencyReward,bin_responseLickFrequencyCost];
    p1 = plot(bin_responseLickFrequencyReward,'b');
    p2 = plot(bin_responseLickFrequencyCost,'r');
    legend([p1 p2],'R','C')
    ylim([min(maxMinArray),max(maxMinArray)])
    ylabel('Response Lick Frequency')
    hold off

    subplot(2,1,2);
    hold on
    p1 = plot(bin_responseRewardTraceSum,'b');
    p2 = plot(bin_responseCostTraceSum,'r');
    maxMinArray = [bin_responseRewardTraceSum,bin_responseCostTraceSum];
    legend([p1 p2],'R','C')
    ylim([min(maxMinArray),max(maxMinArray)])
    xlabel(x_label)
    ylabel('Response Trace Sum')
    hold off

    axes('Position',[0 0 1 1]);
    t = title([title_str,' / ',miceIDs{m},' age: ',num2str(firstSessionAge)]);
    set(gca,'visible','off')
    set(t,'visible','on','Position',[0.5 0.98 0])
    
end
