function individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,health,learned,intendedStriosomality,age,plotType,engagement,learningPeriod, period, traceType, upToLearned, statType, lastTrials)
    if ~isequal('all',learned) 
        if learned
            learned_str = 'learned';
        else 
            learned_str = 'not learned';
        end
    else
        learned_str = 'all animals';
    end
    
    if upToLearned
        upToLearned_str = 'Up to Learning';
    else 
        upToLearned_str = 'Up to Reversal';
    end
    
    if ~strcmp(engagement,'all')
        [~,miceEngagement] = miceTrialEngagement(miceTrials);
    end
    
    animalSlopes = [];
    animalCorr = [];
    animalP = [];
    mouse_dPrime = [];
    mouse_responseTraceArea = [];
    for m = 1:length(miceIDs)
        mouseTrials = miceTrials{m};
        mouseFluorTrials = miceFluorTrials{m};
        rewardTone = rewardTones(m);
        costTone = costTones(m);
        if upToLearned
            learnedFirstTask = first(twdb_lookup(twdb, 'learnedFirstTask', 'key', 'mouseID', miceIDs{m}));
            if learnedFirstTask ~= -1
                mouseTrials = mouseTrials(1:learnedFirstTask,:);
                mouseFluorTrials = mouseFluorTrials(1:learnedFirstTask,:);
            end
        end
        
        if ~isequal('all',engagement) 
            if engagement == 1
                mouseEngagement = logical(miceEngagement{m});
                mouseTrials = mouseTrials(mouseEngagement,:);
                mouseFluorTrials = mouseFluorTrials(mouseEngagement,:);
                engagement_str = 'engagedTriamiceFluorTrials{1}ls';
            else
                mouseEngagement = logical(miceEngagement{m});
                mouseTrials = mouseTrials(~mouseEngagement,:);
                mouseFluorTrials = mouseFluorTrials(~mouseEngagement,:);
                engagement_str = 'notEngagedTrials';
            end
        else
            engagement_str = 'allTrials';
        end
        

        bin_size = round(0.05*height(mouseTrials));

        numTrials = height(mouseTrials);
        numTrials = round(numTrials*learningPeriod);
        
        if lastTrials
            mouseTrials = tail(mouseTrials,numTrials);
            mouseFluorTrials = mouseFluorTrials(end-numTrials:end);
        end

        %rolling window with bin
        bin_dPrime = [];
        bin_responseTraceArea = [];
        rsum = [];
        csum = [];
        bin_responseLickFrequency = [];
        bin_responseTraceSum = [];
        numBins = ceil(numTrials/bin_size);
        for b = numBins:-1:2
            binEnd = numTrials-(numBins-b)*bin_size;
            binStart = binEnd-bin_size+1;
            bin_range = binStart:binEnd;
            bin_fluorTrials = mouseFluorTrials(bin_range,:);
            bin_mouseTrials = mouseTrials(bin_range,:);
            [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
            responseTraceSum = responseRewardTraceSum;
            
            rsum = [rsum responseRewardTraceSum];
            csum = [csum responseCostTraceSum];
            
            if strcmp(traceType,'Rsum')
                responseTraceSum = responseRewardTraceSum;
            elseif strcmp(traceType,'Csum')
                responseTraceSum = responseCostTraceSum;
            end
            
            if isnan(responseTraceArea)
                continue
            end
            
            
            
            bin_dPrime = [bin_dPrime dPrime];
            bin_responseTraceArea = [bin_responseTraceArea responseTraceArea];
            
            bin_responseTraceSum = [bin_responseTraceSum responseTraceSum];

            bin_responseLickFrequency = [bin_responseLickFrequency nanmean(zscore_baseline(bin_mouseTrials.ResponseLickFrequency, mouseTrials.ResponseLickFrequency))];
        end

        mouse_dPrime = [mouse_dPrime bin_dPrime];
        mouse_responseTraceArea = [mouse_responseTraceArea bin_responseTraceArea];
        
        if isequal(plotType,'d-prime')
            y = bin_responseTraceArea;
            x = bin_dPrime;
            y_str = ['Response Period Trace Area Between Reward and Cost'];
            disp(period)
            disp(x)
        elseif isequal(plotType,'Lick Frequency')
            y = bin_responseTraceSum;
            x = bin_responseLickFrequency;
            y_str = ['Response Period Trace Sum'];
            
        end
        [~,m1,b1] = regression(x,y);
        fittedX = (min(x)-0.01):0.01:(max(x)+0.01);
        fittedY = fittedX*m1 + b1;
        cor1 = corr2(x,y);
        [~,P] = corrcoef(x,y); %P-value
        if length(P) > 1
            pval= P(2);
        else
            pval = P;
        end
        
%         subplot(2,5,m)
%         hold on
%         plot(x,y,'ok')
%         plot(fittedX,fittedY,'k','LineWidth',3);
%         xlabel(plotType)
%         ylabel(y_str)
%         title({miceIDs{m},['m=',num2str(m1),'/cor=',num2str(cor1),'/p=',num2str(pval)]})
        
        animalSlopes = [animalSlopes m1];
        animalCorr = [animalCorr cor1];
        animalP = [animalP pval];
        
    end

    if isequal(plotType,'d-prime')
        plotLabel = 'dPrime';
    elseif isequal(plotType,'Lick Frequency')
        plotLabel = 'lickFrequency'; 
    end

    figure
%     subplot(1,3,1)
    hold on
    
    if strcmp(statType, 'slopes')
        bar(nanmean(animalSlopes));
        errorbar(nanmean(animalSlopes),std_error(animalSlopes),'.k','LineWidth',2)
        plot(ones(length(animalSlopes)),animalSlopes,'ks','MarkerFaceColor','k','MarkerSize',8)
        title(['Slope p = ' num2str(signrank(animalSlopes))])
    elseif strcmp(statType, 'p-vals')
        bar(nanmean(animalP));
        errorbar(nanmean(animalP),std_error(animalP),'.k','LineWidth',2)
        plot(ones(length(animalP)),animalP,'ks','MarkerFaceColor','k','MarkerSize',8)
        title(['P-vals'])
    end

    learningPeriodstr = num2str(learningPeriod * 100);
    if lastTrials
        supertitle({[intendedStriosomality ' ' health ' ' learned_str, ' ', period, ' period ', 'last ', learningPeriodstr, '% of trials ', upToLearned_str, ' ', plotType, ' ', traceType, ' ', statType, ''],'',''})
    else
        supertitle({[intendedStriosomality ' ' health ' ' learned_str, ' ', period, ' period ', 'first ', learningPeriodstr, '% of trials ', upToLearned_str, ' ', plotType, ' ', traceType, ' ', statType, ''],'',''})
    end
    
    savefig([intendedStriosomality, ' ',plotType, ' ', traceType, ' ', learningPeriodstr, '% of trials ', period, ' ',upToLearned_str, ' ', statType]);
end