function ksTestDistributions(mouseDistributions,distributionType,sessionTypes)
    
    for n = 1:length(sessionTypes)
        if contains(sessionTypes{n},'regular')
            legendStrings{n} = 'Regular';
            colors{n} = [0.5 0.5 0.5];
        elseif contains(sessionTypes{n},'saline')
            legendStrings{n} = 'Saline';
            colors{n} = 'c';
        elseif contains(sessionTypes{n},'cno')
            legendStrings{n} = 'CNO';  
            colors{n} = [0.3 0.5 0];
        end
    end
    
    sessionTypes1 = sessionTypes{1};
    sessionTypes2 = sessionTypes{2};


    numBins = 10;
        
    distributions1 = mouseDistributions.(sessionTypes1);
    distributions2 = mouseDistributions.(sessionTypes2);
    
    distribution1 = distributions1.(distributionType);
    distribution2 = distributions2.(distributionType);
    
    finalEdges = makeSameBins(distribution1,distribution2,numBins);
    N1 = histcounts(distribution1,finalEdges);
    N2 = histcounts(distribution2,finalEdges);
     
    
    [~, ks_p,ks_stat] = kstest2(distribution1, distribution2);    
    
    plot(finalEdges(1:end-1),cumsum(N1/length(distribution1)),'Color',colors{1},'LineWidth',3)
    plot(finalEdges(1:end-1),cumsum(N2/length(distribution2)),'Color',colors{2},'LineWidth',3)
    xlabel(distributionType)
    xlim([finalEdges(1) finalEdges(end-1)])
    ylim([0 1])
    legend(legendStrings{1},legendStrings{2})
    title({['CDF p=',num2str(ks_p),'/ stat=',num2str(ks_stat)]})
    
end