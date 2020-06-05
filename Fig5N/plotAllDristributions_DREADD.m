function plotAllDristributions_DREADD(miceDistributions,title_str,behaviorDistributionType)


numMice = length(miceDistributions);
for m = 1:numMice
    
    mouseDistributions = miceDistributions(m);
    numberOfMice = mouseDistributions.mouseNum;
    figure('units','normalized','outerposition',[0 0 1 1])
    hold on
    ksTestDistributions(mouseDistributions,behaviorDistributionType,{'salineDistributions','cnoDistributions'})
    hold off
    supertitle({title_str,['n = ' num2str(numberOfMice)],''})
end