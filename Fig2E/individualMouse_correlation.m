function individualMouse_correlation(twdb,health,learned,intendedStriosomality,age,plotType,engagement,learningPeriod)

    if ~isequal('all',learned) 
        if learned
            learned_str = 'learned';
        else 
            learned_str = 'not learned';
        end
    else
        learned_str = 'all animals';
    end
    
    upToLearned = 0;
    if upToLearned
        upToLearned_str = 'Up to Learning';
    else 
        upToLearned_str = 'All Trials';
    end
    
    responsePeriod = 39:46;
    miceIDs = get_mouse_ids(twdb,0,health,learned,intendedStriosomality,'all',age,1,{});
    [miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,upToLearned,0);
    [~,miceEngagement] = miceTrialEngagement(miceTrials);
%     figure('units','normalized','outerposition',[0 0 1 1])
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
        mouseEngagement = logical(miceEngagement{m});
        
        if ~isequal('all',engagement) 
            if engagement == 1
                mouseTrials = mouseTrials(mouseEngagement,:);
                mouseFluorTrials = mouseFluorTrials(mouseEngagement,:);
                engagement_str = 'engagedTrials';
            else
                mouseTrials = mouseTrials(~mouseEngagement,:);
                mouseFluorTrials = mouseFluorTrials(~mouseEngagement,:);
                engagement_str = 'notEngagedTrials';
            end
        else
            engagement_str = 'allTrials';
        end

%         bin_size = round(0.2*height(mouseTrials));
        bin_size = round(0.05*height(mouseTrials));

        numTrials = height(mouseTrials);
        numTrials = round(numTrials*learningPeriod);

        %rolling window with bin
        bin_dPrime = [];
        bin_responseTraceArea = [];
        bin_responseLickFrequency = [];
        bin_responseTraceSum = [];
        numBins = ceil(numTrials/bin_size);
        for b = numBins:-1:2
            binEnd = numTrials-(numBins-b)*bin_size;
            binStart = binEnd-bin_size+1;
            bin_range = binStart:binEnd;
            bin_fluorTrials = mouseFluorTrials(bin_range,:);
            bin_mouseTrials = mouseTrials(bin_range,:);
            [dPrime,responseTraceArea] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
            if isnan(responseTraceArea)
                continue
            end
            
            bin_dPrime = [bin_dPrime dPrime];
            bin_responseTraceArea = [bin_responseTraceArea responseTraceArea];
            bin_responseTraceSum = [bin_responseTraceSum nanmean(sum(bin_fluorTrials(:,responsePeriod),2))];
            bin_responseLickFrequency = [bin_responseLickFrequency nanmean(zscore_baseline(bin_mouseTrials.ResponseLickFrequency, mouseTrials.ResponseLickFrequency))];
        end

        mouse_dPrime = [mouse_dPrime bin_dPrime];
        mouse_responseTraceArea = [mouse_responseTraceArea bin_responseTraceArea];
        
        if isequal(plotType,'d-prime')
            y = bin_responseTraceArea;
            x = bin_dPrime;
            y_str = ['Response Period Trace Area Between Reward and Cost'];
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
%     supertitle({[intendedStriosomality ' ' health ' ' learned_str,' ',engagement_str],'Bin-size = 5% of trials','',''})
    
    if isequal(plotType,'d-prime')
        plotLabel = 'dPrime';
    elseif isequal(plotType,'Lick Frequency')
        plotLabel = 'lickFrequency'; 
    end
%     savefilename = [plotLabel,'_individualPlots_',intendedStriosomality,'_',health,'_',age,'_',learned_str '_' engagement_str];
%     savefig(['/Users/seba/Dropbox (MIT)/UROP/HD_exp/Analysis/Fluorescence Alignment/Individual Plots/',plotType,'/',health,'/',intendedStriosomality,'/',upToLearned_str,'/',savefilename])
%     close
    
    figure
%     subplot(1,3,1)
    hold on
    bar(nanmean(animalSlopes));
    errorbar(nanmean(animalSlopes),std_error(animalSlopes),'.k','LineWidth',2)
    plot(ones(length(animalSlopes)),animalSlopes,'ks','MarkerFaceColor','k','MarkerSize',8)
    title(['Slope p = ' num2str(signrank(animalSlopes))])
%     subplot(1,3,2)
%     hold on
%     bar(nanmean(animalCorr));
%     errorbar(nanmean(animalCorr),std_error(animalCorr),'.k','LineWidth',2)
%     plot(ones(length(animalCorr)),animalCorr,'ks','MarkerFaceColor','k','MarkerSize',8)
%     title('Pearson Correlation')
%     subplot(1,3,3)
%     hold on
%     bar(nanmean(animalP));
%     errorbar(nanmean(animalP),std_error(animalP),'.k','LineWidth',2)
%     plot(ones(length(animalP)),animalP,'ks','MarkerFaceColor','k','MarkerSize',8)
%     title('p-value')
    supertitle({[intendedStriosomality ' ' health ' ' learned_str,' ',engagement_str],'',''})
%     savefilename = [plotLabel,'_slopes_',intendedStriosomality,'_',health,'_',age,'_',learned_str '_' engagement_str];
%     savefig(['/Users/seba/Dropbox (MIT)/UROP/HD_exp/Analysis/Fluorescence Alignment/Individual Plots/',plotType,'/',health,'/',intendedStriosomality,'/',upToLearned_str,'/',savefilename])
%     close

end