function [r1, m1, dp_overall,area_overall, b1] = engagement_trace_correlation_LR_fin(bin_size,miceTrials,miceFluorTrials,rewardTone,costTone,miceIDs,want_engaged,plot_all,want_area,want_reward,want_cost,want_licks,want_c,want_dp, d_vs_c,epoch_str)
    % want_engaged = 1 if want engaged trials, 0 if want not engaged trials
    % plot_all = 1 if all trials (both E + NE) --> (this must be 0 if you
                                    % want only engaged or only not engaged)
    % want_area = 1 if want area btwn curves,
    % want_reward = 1 if reward trace
    % want_cost = 1 if cost trace
    % want_licks = 1 if want licks 
    % want_c = 1 if want_c 
    % want_dp = 1 if want_dp
    % d_vs_c = 1 then d on x axis, c on y axis

    plot_first_fig = 0;
    plot_second_fig = 1;
    plot_R = 0;
    want_title = 1;
    
    responsePeriod = 39:46;
    area_overall = [];
    engagement_overall = [];
    dp_overall = [];
    c_overall = [];
    licks_overall = [];
    for m = 1:length(miceIDs)
        mouseTrials = miceTrials;
        mouseFluorTrials = miceFluorTrials;
        
        if ~plot_all
            if want_engaged
                engagement_idx = mouseTrials.NewEngagement == 1;   
            else
                engagement_idx = mouseTrials.NewEngagement == 0;
            end
        else
           engagement_idx = ones(height(mouseTrials),1);
        end
        
        engaged_trials = mouseTrials(engagement_idx,:);
        engaged_fluor = mouseFluorTrials(engagement_idx,:);
        [~,~,rewardFluorTrials_engaged,costFluorTrials_engaged] = reward_and_cost_trials(mouseTrials(engagement_idx,:),mouseFluorTrials(engagement_idx,:),rewardTone,costTone);
        
        [mReward_engaged, ~, ~] = get_dist_stats(rewardFluorTrials_engaged);
        [mCost_engaged, ~, ~] = get_dist_stats(costFluorTrials_engaged);
        responseRewardTrace_engaged = mReward_engaged(responsePeriod);
        responseCostTrace_engaged = mCost_engaged(responsePeriod);
        
        if want_area 
            responseTraceArea_engaged(m) = sum(responseRewardTrace_engaged-responseCostTrace_engaged);
        end
        if want_reward
            responseTraceArea_engaged(m) = sum(responseRewardTrace_engaged);
        end
        if want_cost
           responseTraceArea_engaged(m) = sum(responseCostTrace_engaged);
        end
        
        if plot_all
            numTrials = height(mouseTrials);
        else
            numTrials = height(engaged_trials);
        end
        
        numBins = ceil(numTrials/bin_size);
            
        for n = numBins:-1:1
            binEnd = numTrials-(numBins-n)*bin_size;
            if n == 1
                binStart = 1;
            else
                binStart = binEnd-bin_size+1;
            end
            
            if plot_all
                bin_mouseTrials = mouseTrials(binStart:binEnd,:);
                bin_fluorTrials = mouseFluorTrials(binStart:binEnd,:);
            else
                % engaged or not engaged, depending on what engagement_idx
                bin_dp = engaged_trials(binStart:binEnd,:);
                bin_e_fluorTrials = engaged_fluor(binStart:binEnd,:);
            end
           

            if n > 1
                if plot_all 
                    [~,~,bin_rewardFluorTrials,bin_costFluorTrials] = reward_and_cost_trials(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
                else
                    [~,~,bin_rewardFluorTrials,bin_costFluorTrials] = reward_and_cost_trials(bin_dp,bin_e_fluorTrials,rewardTone,costTone);
                end
                [bin_mReward, ~, ~] = get_dist_stats(bin_rewardFluorTrials);
                [bin_mCost, ~, ~] = get_dist_stats(bin_costFluorTrials);
                if sum(isnan(bin_mReward)) || sum(isnan(bin_mCost))
                    continue
                end

                bin_responseRewardTrace = bin_mReward(responsePeriod);
                bin_responseCostTrace = bin_mCost(responsePeriod);
                bin_responseTraceArea = sum(bin_responseRewardTrace-bin_responseCostTrace);
                if want_area
                    area_overall = [area_overall bin_responseTraceArea];
                end
                if want_reward 
                    area_overall = [area_overall sum(bin_responseRewardTrace)];
                end
                if want_cost
                    area_overall = [area_overall sum(bin_responseCostTrace)];
                end

                if plot_all
                    %bin_engagement = bin_mouseTrials.NewEngagement;
                    bin_engagement = ones(height(bin_mouseTrials),1);
                    engagement_overall = [engagement_overall nanmean(bin_engagement)];
                    
                    licks = bin_mouseTrials.ResponseLickFrequency;
                    [~, ~, dp, c] = roc_analysis_trials_JF(bin_mouseTrials, rewardTone, costTone);
                    
                else
                    licks = bin_dp.ResponseLickFrequency;
                    [~, ~, dp, c] = roc_analysis_trials_JF(bin_dp, rewardTone, costTone);
                end
                
               dp_overall = [dp_overall dp];
               c_overall = [c_overall c];
               licks_overall = [licks_overall mean(licks)];
            end
        end
    end
    
    if plot_first_fig
        figure
        hold on
        bar(1,nanmean(responseTraceArea_engaged))
        bar(2,nanmean(responseTraceArea_notEngaged))
        errorbar(1,nanmean(responseTraceArea_engaged),std_error(responseTraceArea_engaged),'.b')
        errorbar(2,nanmean(responseTraceArea_notEngaged),std_error(responseTraceArea_notEngaged),'.r')
        plot(ones(1,length(miceIDs)),responseTraceArea_engaged,'ob','MarkerFaceColor','b')
        plot(2*ones(1,length(miceIDs)),responseTraceArea_notEngaged,'or','MarkerFaceColor','r')
        set(gca,'XTickLabel', {'Engaged Trials', 'Not Engaged Trials'},'XTick',1:2);
        ylabel('Area between Reward and Cost Traces in Response Period')
        hold off
        [~,P] = ttest(responseTraceArea_engaged,responseTraceArea_notEngaged);
        [~,P_unpaired] = ttest2(responseTraceArea_engaged,responseTraceArea_notEngaged);
        suptitle({[health ' ' striosomality ' ' learned_str ' N=' num2str(length(miceIDs))],...
            [state_str 'Paired t-test p-val: ' num2str(P) ' / Unpaired t-test p-val: ' num2str(P_unpaired)]})

    end
    
    
    if plot_R
       subplot(2,1,1)
    else
        figure
    end
    
    hold on
    
    
        % replace engagement_overall with d prime data
        if want_licks
            x = licks_overall;
            xlabel('Licks')
        elseif want_dp || d_vs_c
            % d vs area or d vs c - d on x axis
            x = dp_overall;
            xlabel('DP')
        elseif want_c
            x = c_overall;
            xlabel('C')
        end

        if want_area
            % sum on y axis
            y = area_overall;
            ylabel('Area')  
        elseif d_vs_c
            % c on y axis
            y = c_overall;
            ylabel('C')
        elseif want_reward
            % reward trace on y axis
            y = area_overall;
            ylabel('Reward')
        elseif want_cost
            % cost trace on y axis
            y = area_overall;
            ylabel('Cost')
        end
        
        plot(x,y,'ok')
        [~,m1,b1]=regression(x,y);
        fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
        fittedY=fittedX*m1+b1;
        [cor1,P] = corrcoef(x,y); %P-value
    
        if plot_second_fig
            plot(x,y,'ok')
            plot(fittedX,fittedY,'k','LineWidth',3);
        end

        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end

        if want_title
            
            title({[miceIDs{m} ' ' epoch_str],['Pearson Corr Coef = ' num2str(cor1(2)) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval) ' bin size ' num2str(bin_size)]})
        end
        hold off
    

    %For amount of datapoints
    color_str = {[1 1 0],[1 0.5 0],[1 0 0]};
    %Linear Regression and Correlation
    [r1,m1,b1]=regression(x,y);
    %fittedX=(0-(eng_size/2)):0.01:(1-(eng_size/2));
    fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
    fittedY=fittedX*m1+b1;
    
    %cor1 = corr2(x,y);
    [cor1,P] = corrcoef(x,y); %P-value
    if length(P) > 1
        pval = P(2);
    else
        pval = P;
    end

    if plot_R
        subplot(2,1,2)
        bar(r1);
        title('R')
        xlabel('Window Start (Bin #')
        ylabel('R')
    end
        