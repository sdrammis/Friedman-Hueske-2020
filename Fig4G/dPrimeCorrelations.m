function [area_slope,area_R,area_Pval,reward_slope,reward_R,reward_Pval,cost_slope,cost_R,cost_Pval] = dPrimeCorrelations(title_str,mouseID,mouseTrials,mouseFluorTrials,rewardTone,costTone,engagement,xType)

graph = 0;

area_slope = NaN;
area_R = NaN;
area_Pval = NaN;
reward_slope = NaN;
reward_R = NaN;
reward_Pval = NaN;
cost_slope = NaN;
cost_R = NaN;
cost_Pval = NaN;

if engagement
    engagementStr = 'engaged';
else   
    engagementStr = 'not engaged';
end


engagedRange = mouseTrials.Engagement == engagement;
if ~sum(engagedRange)
    return
end

mouseTrials = mouseTrials(engagedRange,:);
mouseFluorTrials = mouseFluorTrials(engagedRange,:);

numTrials = height(mouseTrials);
numBins = 5;
bin_size = round(numTrials/numBins);
bins = fliplr(numTrials:-bin_size:0);
if length(bins) < numBins + 1
    bins = [1 bins];
end

bin_dPrime = [];
bin_c = [];
bin_tpr = [];
bin_fpr = [];
bin_responseTraceArea = [];
bin_responseRewardTraceSum = [];
bin_responseCostTraceSum = [];
for b = 1:length(bins)-1
    bin_range = bins(b)+1:bins(b+1);
    bin_fluorTrials = mouseFluorTrials(bin_range,:);
    bin_mouseTrials = mouseTrials(bin_range,:);
    [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c,tpr,fpr]...
        = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
    
    if isnan(responseTraceArea)
        continue
    end
    
    bin_dPrime = [bin_dPrime dPrime];
    bin_c = [bin_c c];
    bin_tpr = [bin_tpr tpr];
    bin_fpr = [bin_fpr fpr];
    bin_responseTraceArea = [bin_responseTraceArea responseTraceArea];
    bin_responseRewardTraceSum = [bin_responseRewardTraceSum responseRewardTraceSum];
    bin_responseCostTraceSum = [bin_responseCostTraceSum responseCostTraceSum];
    
end

if isempty(bin_responseTraceArea)
    return
end

if graph
    figure('units','normalized','outerposition',[0 0 1 1])
end

y = bin_responseTraceArea;
if isequal(xType,'c')
    x = bin_c;
else 
    x = bin_dPrime;
end
[~,slope,b1] = regression(x,y);
fittedX = (min(x)-0.01):0.01:(max(x)+0.01);
fittedY = fittedX*slope + b1;
R = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval= P(2);
else
    pval = P;
end

if graph
    subplot(3,1,1)
    hold on
    plot(x,y,'ok')
    plot(fittedX,fittedY,'k','LineWidth',3);
    if ~isequal(xType,'c')
        xlabel('d-prime')
    else
        xlabel('c')
    end
    ylabel('Response Trace Area')
    title({[title_str ' ' engagementStr],mouseID,'Area',['m=',num2str(slope),'/cor=',num2str(R),'/p=',num2str(pval)]})
end

area_slope = slope;
area_R = R;
area_Pval = pval;

y = bin_responseRewardTraceSum;
if isequal(xType,'dPrime')
    x = bin_dPrime;
elseif isequal(xType,'Acceptance Rate')
    x = bin_tpr;
elseif isequal(xType,'c')
    x = bin_c;
end

[~,slope,b1] = regression(x,y);
fittedX = (min(x)-0.01):0.01:(max(x)+0.01);
fittedY = fittedX*slope + b1;
R = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval= P(2);
else
    pval = P;
end

if graph
    subplot(3,1,2)
    hold on
    plot(x,y,'ok')
    plot(fittedX,fittedY,'k','LineWidth',3);
    xlabel(xType)
    ylabel('Response Reward Sum')
    title({'Reward',['m=',num2str(slope),'/cor=',num2str(R),'/p=',num2str(pval)]})
end

reward_slope = slope;
reward_R = R;
reward_Pval = pval;

y = bin_responseCostTraceSum;
if isequal(xType,'dPrime')
    x = bin_dPrime;
elseif isequal(xType,'Acceptance Rate')
    x = bin_fpr;
elseif isequal(xType,'c')
    x = bin_c;
end
[~,slope,b1] = regression(x,y);
fittedX = (min(x)-0.01):0.01:(max(x)+0.01);
fittedY = fittedX*slope + b1;
R = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval= P(2);
else
    pval = P;
end

if graph
    subplot(3,1,3)
    hold on
    plot(x,y,'ok')
    plot(fittedX,fittedY,'k','LineWidth',3);
    xlabel(xType)
    ylabel('Response Cost Sum')
    title({'Cost',['m=',num2str(slope),'/cor=',num2str(R),'/p=',num2str(pval)]})
end

cost_slope = slope;
cost_R = R;
cost_Pval = pval;

if graph
    saveDir = [pwd filesep xType ' correlations' filesep num2str(numBins) ' bins' filesep title_str filesep engagementStr];
    if ~isfolder(saveDir)
        mkdir(saveDir)
    end
    savefig([saveDir filesep mouseID])
    close
end