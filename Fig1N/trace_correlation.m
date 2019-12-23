function trace_correlation(twdb,bin_size,trialPeriod,calcType,health,striosomality,learned,engagement,zscore,learningPeriod)

    miceIDs = get_mouse_ids(twdb,0,health,learned,striosomality,'all','all',1,{});
    dp_overall = [];
    c_overall = [];
    peakReward_overall = [];
    peakCost_overall = [];
    peakDifference_overall = [];
    area_overall = [];
    rewardLicks_overall = [];
    costLicks_overall = [];
    sumReward_overall = [];
    sumCost_overall = [];
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        [bin_fluorRewardTrials,bin_fluorCostTrials,bin_lickRewardTrials,bin_lickCostTrials]...
            = get_fluorescence_mouse_sta(twdb, mouseID, bin_size, engagement, zscore, learningPeriod);
        
        for b = 2:length(bin_fluorRewardTrials)
            fluorRewardTrials = bin_fluorRewardTrials{b};
            [mReward, ~, ~] = get_dist_stats(fluorRewardTrials);
            fluorCostTrials = bin_fluorCostTrials{b};
            [mCost, ~, ~] = get_dist_stats(fluorCostTrials);
            
            if sum(isnan(mReward)) || sum(isnan(mCost))
                continue
            end
            
            if isequal(trialPeriod,'Response')
                periodReward = mReward(39:46);
                periodCost = mCost(39:46);
            elseif isequal(trialPeriod,'Outcome')
                periodReward = mReward(39:46);
                periodCost = mCost(39:46);
            end
            if isequal(calcType,'Peak')
                peakReward = max(periodReward);
                peakCost = max(periodCost);
                peakDifference = peakReward-peakCost;
                peakReward_overall = [peakReward_overall peakReward];
                peakCost_overall = [peakCost_overall peakCost];
                peakDifference_overall = [peakDifference_overall peakDifference];
            elseif isequal(calcType,'Sum')
                sumReward = sum(periodReward);
                sumReward_overall = [sumReward_overall sumReward];
                sumCost = sum(periodCost);
                sumCost_overall = [sumCost_overall sumCost];
            elseif isequal(calcType,'Area')
                periodArea = sum(periodReward-periodCost);
                area_overall = [area_overall periodArea];
            end
            
            lickRewardTrials = bin_lickRewardTrials{b};
            lickCostTrials = bin_lickCostTrials{b};
            
            rewardLicks_overall = [rewardLicks_overall nanmean(lickRewardTrials)];
            costLicks_overall = [costLicks_overall nanmean(lickCostTrials)];
            
            [~, ~, dp_bin, c_bin] = dprime_and_c_licks(lickRewardTrials,lickCostTrials);
            dp_overall = [dp_overall dp_bin];
            c_overall = [c_overall c_bin];
        end
    end
    
    if zscore
        figure
        hold on
        if isequal(calcType,'Peak')
            reward_stat_overall = peakReward_overall;
            cost_stat_overall = peakCost_overall;
            y_str = ['Peak ' trialPeriod ' Period Trace'];
        elseif isequal(calcType,'Area')
            reward_stat_overall = area_overall;
            cost_stat_overall = area_overall;
            y_str = ['Area between Reward and Cost Traces in ' trialPeriod ' Period'];
        elseif isequal(calcType,'Sum')
            reward_stat_overall = sumReward_overall;
            cost_stat_overall = sumCost_overall;
            y_str = ['Sum of ' trialPeriod ' Period Trace'];
        end
        plot(rewardLicks_overall,reward_stat_overall,'ob')
        plot(costLicks_overall,cost_stat_overall,'or')
        
        x = rewardLicks_overall;
        y = reward_stat_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'b','LineWidth',3);
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        reward_str = ['Reward: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];
        
        x = costLicks_overall;
        y = cost_stat_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'r','LineWidth',3);
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        cost_str = ['Cost: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];
        
        xlabel([trialPeriod ' Lick Z-Scores'])
        ylabel(y_str)
        legend('Reward Tone','Cost Tone')
        title([reward_str ' / ' cost_str])
        hold off
        
    elseif isequal(calcType,'Peak')
        figure

        subplot(2,2,1)    
        hold on
        plot(dp_overall,peakReward_overall,'ob')
        plot(dp_overall,peakCost_overall,'or')

        x = dp_overall;
        y = peakReward_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'b','LineWidth',3);
        if length(P) > 1
            pval = P(2);
        else
            pval = P;
        end
        reward_str = ['Reward: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];

        x = dp_overall;
        y = peakCost_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'r','LineWidth',3);
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        cost_str = ['Cost: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];


        xlabel('d-prime')
        ylabel(['Peak ' trialPeriod ' Period Trace'])
        legend('Reward Tone','Cost Tone')
        title({reward_str,cost_str})

        hold off

        subplot(2,2,2)
        hold on
        plot(c_overall,peakReward_overall,'ob')
        plot(c_overall,peakCost_overall,'or')

        x = c_overall;
        y = peakReward_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'b','LineWidth',3);
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        reward_str = ['Reward: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];

        x = c_overall;
        y = peakCost_overall;
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        plot(fittedX,fittedY,'r','LineWidth',3);
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        cost_str = ['Cost: Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)];

        xlabel('c')
        ylabel(['Peak ' trialPeriod ' Period Trace'])
        legend('Reward Tone','Cost Tone')
        title({reward_str,cost_str})
        hold off

        subplot(2,2,3)
        hold on
        plot(dp_overall,peakDifference_overall,'ok')

        x = dp_overall;
        y = peakDifference_overall;
        [~,m1,b1]=regression(x,y);
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

        xlabel('d-prime')
        ylabel(['Peak ' trialPeriod ' Period Trace Difference Between Reward and Cost'])
        title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])
        hold off

        subplot(2,2,4)
        hold on
        plot(c_overall,peakDifference_overall,'ok')

        x = c_overall;
        y = peakDifference_overall;
        [~,m1,b1]=regression(x,y);
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


        xlabel('c')
        ylabel(['Peak ' trialPeriod ' Period Trace Difference Between Reward and Cost'])
        title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])
        hold off
        
    elseif isequal(calcType,'Area')
        figure
        subplot(2,1,1)
        hold on
        plot(dp_overall,area_overall,'ok')

        x = dp_overall;
        y = area_overall;
        [~,m1,b1]=regression(x,y);
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

        xlabel('d-prime')
        ylabel(['Area between Reward and Cost Traces in ' trialPeriod ' Period'])
        title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])
        hold off

        %Lick Z-score Bins
        dp_size = 0.2;
        begin = round(min(dp_overall),1)-0.1;
        if rem(begin,dp_size)
            begin = begin-0.1;
        end
        ending = round(max(dp_overall),1)+0.1;
        if rem(ending,dp_size)
            ending = ending+0.1;
        end
        x = begin:dp_size:ending;
        byDP = cell(1,length(x)-1);
        for n=1:length(x)-1
            byDP{n} = [byDP{n} area_overall(and(dp_overall<x(n+1),dp_overall>=x(n)))];
        end
        %Parameters for Striosomal Z-scores
        y = cellfun(@nanmean,byDP); %Z-Score mean per bin
        y_std = cellfun(@nanstd,byDP); %Z-score STD per bin
        len = cellfun(@length,byDP); %Amount of datapoints per bin
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
        plot(fittedX+(dp_size/2),fittedY,'k','LineWidth',3);%Plots line of best fit
        errorbar(x+(dp_size/2),y,y_err,'.k')
        for n=1:length(x)%Plots each point indicating amount of datapoints per bin
            if floor(log10(len(n))+1)==1
                p(1) = plot(x(n)+(dp_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
            elseif floor(log10(len(n))+1)==2
                p(2) = plot(x(n)+(dp_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
            elseif floor(log10(len(n))+1)==3
                p(3) = plot(x(n)+(dp_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
            end
        end

        xlabel('d-prime')
        ylabel(['Area between Reward and Cost Traces in ' trialPeriod ' Period'])
        title({['Mean of Bins, Bin Size = ' num2str(dp_size)],...
            ['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)]})
        axis tight
        hold off
    end
    
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
    