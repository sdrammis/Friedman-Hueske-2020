function overallCorrelation(twdb,bin_size,dp_size,intendedStriosomality,health,learned,age,engagement,xType,yType)

    ageCutoff = 15;

    if learned
        learned_str = 'learned';
    else 
        learned_str = 'not_learned';
    end
    fileDir = '/Users/seba/Dropbox (MIT)/UROP/HD_exp/Analysis/Photometry Files/First Task/';
    load([fileDir intendedStriosomality '_' health '_' learned_str])
    
    numMice = 0;
    x_overall = [];
    y_overall = [];
    for m = 1:length(miceIDs)
        
        mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
        if isequal(age,'young') && mouseAge > ageCutoff
            continue
        elseif isequal(age,'old') && mouseAge <= ageCutoff
            continue
        end
        
        mouseTrials = miceTrials{m};
        mouseFluorTrials = miceFluorTrials{m};
        rewardTone = rewardTones(m);
        costTone = costTones(m);
        
        if ~isequal('all',engagement)
            mouseFluorTrials = mouseFluorTrials(mouseTrials.Engagement == engagement,:);
            mouseTrials = mouseTrials(mouseTrials.Engagement == engagement,:);
        end
        
        numTrials = height(mouseTrials);
        bins = fliplr(numTrials:-bin_size:0);
        mouse_dPrime = [];
        mouse_c = [];
        mouse_tpr = [];
        mouse_fpr = [];
        mouse_area = [];
        mouse_reward = [];
        mouse_cost = [];
        for b = 1:length(bins)-1
            bin_range = bins(b)+1:bins(b+1);
            bin_fluorTrials = mouseFluorTrials(bin_range,:);
            bin_mouseTrials = mouseTrials(bin_range,:);
            [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
            if isnan(responseTraceArea)
                continue
            end
            
            mouse_dPrime = [mouse_dPrime dPrime];
            mouse_c = [mouse_c c];
            mouse_tpr = [mouse_tpr tpr];
            mouse_fpr = [mouse_fpr fpr];
            mouse_area = [mouse_area responseTraceArea];
            mouse_reward = [mouse_reward responseRewardTraceSum];
            mouse_cost = [mouse_cost responseCostTraceSum];
        end
        
        if isequal(xType,'dPrime')
            x_overall = [x_overall mouse_dPrime];
        elseif isequal(xType,'c')
            x_overall = [x_overall mouse_c];
        elseif isequal(xType,'fpr')
            x_overall = [x_overall mouse_fpr];
        end
        
        if isequal(yType,'Area')
            y_overall = [y_overall mouse_area];
        elseif isequal(yType,'Reward')
            y_overall = [y_overall mouse_reward];
        elseif isequal(yType,'Cost')
            y_overall = [y_overall mouse_cost];
        elseif isequal(yType,'c')
            y_overall = [y_overall mouse_c];
        elseif isequal(yType,'dPrime')
            y_overall = [y_overall mouse_dPrime];
        elseif isequal(yType,'tpr')
            y_overall = [y_overall mouse_tpr];
        end
        numMice = numMice + 1;
    end
    
    
      
    figure
    subplot(2,1,1)
    hold on
    plot(x_overall,y_overall,'ok')

    x = x_overall;
    y = y_overall;
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

    xlabel(xType)
    ylabel(yType)
    title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])
    hold off

    begin = round(min(x_overall),1)-0.1;
    if rem(begin,dp_size)
        begin = begin-0.1;
    end
    ending = round(max(x_overall),1)+0.1;
    if rem(ending,dp_size)
        ending = ending+0.1;
    end
    x = begin:dp_size:ending;
    byDP = cell(1,length(x)-1);
    for n=1:length(x)-1
        byDP{n} = [byDP{n} y_overall(and(x_overall<x(n+1),x_overall>=x(n)))];
    end
    %Parameters for Striosomal Z-scores
    y = cellfun(@nanmean,byDP); %Z-Score mean per bin
    y_std = cellfun(@nanstd,byDP); %Z-score STD per bin
    len = cellfun(@length,byDP); %Amount of datapoints per bin
    %Removes bins w/o datapoints
    thresh = 1;
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

    xlabel(xType)
    ylabel(yType)
    title({['Mean of Bins, Bin Size = ' num2str(dp_size)],...
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
    

    supertitle({[intendedStriosomality ' ' health  ' ' learned_str ' ' age ' N=' num2str(numMice)]...
        ,['Bin Size: ' num2str(bin_size), eng_str],'',''})
    