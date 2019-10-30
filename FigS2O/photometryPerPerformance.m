function photometryPerPerformance(twdb,health,intendedStriosomality,learned)

ageCutoff = 12;
reversal = 0;
miceIDs = get_mouse_ids(twdb,reversal,health,learned,intendedStriosomality,'all','old',1,{});
upToLearned = 0;
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,upToLearned,reversal);

if learned
    learned_str = 'learned';
else 
    learned_str = 'not learned';
end
title_str = [intendedStriosomality ' ' health ' ' learned_str];

figure('units','normalized','outerposition',[0 0 1 1])

bin_size = 10;
numAges = 1;
numRowsPlots = 2*numAges;
numPeriods = 1;
numPerformances = 2;
plottingRows = {[1 3],[2 4]};
dPrimeRanges = {[0 0.25],[2 Inf]};
performanceTitles = {['dPrime Range = ',num2str(dPrimeRanges{1}(1)),'-',num2str(dPrimeRanges{1}(2))],['dPrime Range = ',num2str(dPrimeRanges{2}(1)),'-',num2str(dPrimeRanges{2}(2))]};

for p = 1:numPerformances
    fluorRewardTrials = cell(numAges,numPeriods);
    fluorCostTrials = cell(numAges,numPeriods);
    for m = 1:length(miceIDs)
        mouseTrials = miceTrials{m};
        mouseFluorTrials = miceFluorTrials{m};
        rewardTone = rewardTones(m);
        costTone = costTones(m);
        mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
        ageIdx = (mouseAge > ageCutoff);

        [rewardFluorTrials,costFluorTrials] = dPrimeRange(dPrimeRanges{p},bin_size,mouseTrials,mouseFluorTrials,rewardTone,costTone);      
        learningPeriod = 1;
        fluorRewardTrials{ageIdx,learningPeriod} = [fluorRewardTrials{ageIdx,learningPeriod}; get_dist_stats(rewardFluorTrials)];
        fluorCostTrials{ageIdx,learningPeriod} = [fluorCostTrials{ageIdx,learningPeriod}; get_dist_stats(costFluorTrials)];

    end

    ageStr = {['Young (age<=' num2str(ageCutoff) ')'],['Old (age>' num2str(ageCutoff) ')']};
    periodStr = {'Learning','Post learning','All Trials'};

    
    for n = 1:numAges
        for learningPeriod = 1:numPeriods
            subplot(numAges*numPerformances,numPeriods,(plottingRows{p}(n)-1)*numPeriods + learningPeriod)
            hold on;
            plot(1:98,ones(1,98)*0.5,'k--')
            plot(1:98,ones(1,98)*0,'k--')
            plot(1:98,ones(1,98)*-0.5,'k--')
            plotPhotometryTraces(fluorRewardTrials{n,learningPeriod},fluorCostTrials{n,learningPeriod})
            numAnimals = sum(~sum(isnan(fluorRewardTrials{n,learningPeriod}),2));
            title({[ageStr{n},', n=',num2str(numAnimals)],[performanceTitles{p} ' ' periodStr{learningPeriod}]})
        end

    end
end
supertitle({title_str,'',''})