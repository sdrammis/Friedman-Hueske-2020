function licks_trace_correlation(twdb,bin_size,lick_bin_size,trialPeriod,health,striosomality,learned,engagement,zscore,learningPeriod)
    
    if ~isequal(engagement,'all') && engagement == 1
        exceptions = {'2593','2787','3001','3004'};
    else
        exceptions = {};
    end
    
    miceIDs = get_mouse_ids(twdb,0,health,learned,striosomality,'all','all',1,exceptions);

    rewardLicks_overall = [];
    costLicks_overall = [];
    sumReward_overall = [];
    sumCost_overall = [];
    sum_overall = [];
    licks_overall = [];
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        if isequal(trialPeriod,'Response')
            [bin_fluorRewardTrials,bin_fluorCostTrials,bin_lickRewardTrials,bin_lickCostTrials]...
                = get_fluorescence_mouse_sta(twdb, mouseID, bin_size, engagement, zscore, learningPeriod);
        elseif isequal(trialPeriod,'Outcome')
            [bin_fluorRewardTrials,bin_fluorCostTrials,bin_lickRewardTrials,bin_lickCostTrials]...
                = get_fluorescence_mouse_outcome(twdb, mouseID, bin_size, engagement, zscore, learningPeriod);
        end
        for b = 2:length(bin_fluorRewardTrials)

            fluorRewardTrials = bin_fluorRewardTrials{b};
            fluorCostTrials = bin_fluorCostTrials{b};
            if isequal(trialPeriod,'Response')
                periodReward = nanmean(sum(fluorRewardTrials(:,39:46),2));
                periodCost = nanmean(sum(fluorCostTrials(:,39:46),2));
                period_all = nanmean([sum(fluorCostTrials(:,39:46),2)' sum(fluorRewardTrials(:,39:46),2)']);
                if isnan(periodReward) || isnan(periodCost)
                    continue;
                end
            elseif isequal(trialPeriod,'Outcome')
                empty_rewardIds = cellfun(@isempty,fluorRewardTrials);
                reward_sum = cell2mat(fluorRewardTrials(~empty_rewardIds));
                periodReward = nanmean(reward_sum);
                empty_costIds = cellfun(@isempty,fluorCostTrials);
                cost_sum = cell2mat(fluorCostTrials(~empty_costIds));
                periodCost = nanmean(cost_sum);
                period_all = nanmean([cost_sum reward_sum]);
                if ~sum(~empty_rewardIds) || ~sum(~empty_costIds)
                    continue;
                end
            end

            sumReward_overall = [sumReward_overall periodReward];
            sumCost_overall = [sumCost_overall periodCost];
            sum_overall = [sum_overall period_all];

            lickRewardTrials = bin_lickRewardTrials{b};
            lickCostTrials = bin_lickCostTrials{b};

            rewardLicks_overall = [rewardLicks_overall nanmean(lickRewardTrials)];
            costLicks_overall = [costLicks_overall nanmean(lickCostTrials)];
            licks_overall = [licks_overall nanmean([lickCostTrials' lickRewardTrials'])];
        end
    end
    
    x = licks_overall;
    y = sum_overall;
%     x = rewardLicks_overall;
%     y = sumReward_overall;
    
    figure
    subplot(2,1,1)
    hold on
    y_str = ['Sum of ' trialPeriod ' Period Trace'];
    if isequal(trialPeriod,'Outcome')
        y_str = [y_str ' (Z-Score)'];
    end
    plot(x,y,'ok')

    
    [~,m1,b1] = regression(x,y);
    fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
    fittedY=fittedX*m1+b1;
    cor1 = corr2(x,y);
    [~,P] = corrcoef(x,y); %P-value
    plot(fittedX,fittedY,'k','LineWidth',3);
    if length(P) > 1
        pval= P(2);
    else
        pval = P;
    end
    xlabel([trialPeriod ' Lick Z-Scores'])
    ylabel(y_str)
    title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])
    axis tight
    hold off
    
    %Lick Z-score Bins
%     lick_bin_size = 0.2;
    begin = round(min(licks_overall),1)-0.1;
    if rem(begin,0.2)
        begin = begin-0.1;
    end
    ending = round(max(licks_overall),1)+0.1;
    if rem(ending,0.2)
        ending = ending+0.1;
    end
    x = begin:lick_bin_size:ending;
    byLick = cell(1,length(x)-1);
    for n=1:length(x)-1
        byLick{n} = [byLick{n} sum_overall(and(licks_overall<x(n+1),licks_overall>=x(n)))];
    end
    %Parameters for Striosomal Z-scores
    y = cellfun(@nanmean,byLick); %Z-Score mean per bin
    y_std = cellfun(@nanstd,byLick); %Z-score STD per bin
    len = cellfun(@length,byLick); %Amount of datapoints per bin
    %Removes bins w/o datapoints
    thresh = 0;
    x = x(len>thresh);
    y = y(len>thresh);
    y_std = y_std(len>thresh);
    len = len(len>thresh);
    y_err = y_std./sqrt(len);
    
    %For amount of datapoints
    color_str = {[1 1 0],[1 0.5 0],[1 0 0]};
    %Linear Regression and Correlation
    [~,m1,b1]=regression(x,y);
    % fittedX=min(x-x_error):0.01:max(x_error+x);
    fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
    fittedY=fittedX*m1+b1;
    cor1 = corr2(x,y);
    [~,P] = corrcoef(x,y); %P-value
    if length(P) > 1
        pval = P(2);
    else
        pval = P;
    end
    
    subplot(2,1,2)
    hold on
    plot(fittedX+(lick_bin_size/2),fittedY,'k','LineWidth',3);%Plots line of best fit
    errorbar(x+(lick_bin_size/2),y,y_err,'.k')
    for n=1:length(x)%Plots each point indicating amount of datapoints per bin
        if floor(log10(len(n))+1)==1
            p(1) = plot(x(n)+(lick_bin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
        elseif floor(log10(len(n))+1)==2
            p(2) = plot(x(n)+(lick_bin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
        elseif floor(log10(len(n))+1)==3
            p(3) = plot(x(n)+(lick_bin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
        end
    end
    
    xlabel([trialPeriod ' Lick Z-Scores'])
    ylabel(y_str)
    title({['Mean of Bins, Bin Size = ' num2str(lick_bin_size)],...
        ['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)]})
    axis tight
    hold off
    
    if ~isequal(learned,'all')
        if learned
            learned_str = 'learned';
        else
            learned_str = 'not learned';
        end
    else
        learned_str = 'all mice';
    end
    
    if isequal(engagement,'all')
        eng_str = ' All Trials';
    elseif engagement
        eng_str = ' Engaged Trials';
    elseif ~engagement
        eng_str = ' Not-Engaged Trials';
    end
    
    if learningPeriod == 1
        period_str = 'All Trials Included';
    else
        period_str = ['First ' num2str(learningPeriod) ' of Trials Included'];
    end
    
    supertitle({[ health ' ' striosomality ' ' learned_str ' N=' num2str(length(miceIDs))],...
        [trialPeriod ' Period / ' period_str],['Bin Size: ' num2str(bin_size), eng_str],'',''})