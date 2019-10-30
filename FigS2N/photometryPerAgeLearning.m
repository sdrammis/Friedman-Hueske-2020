function photometryPerAgeLearning(twdb,health,intendedStriosomality,learned,age)

ageIdx = 1;
reversal = 0;
miceIDs = get_mouse_ids(twdb,reversal,health,learned,intendedStriosomality,'all',age,1,{});
upToLearned = 0;
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,upToLearned,reversal);


firstLearningPeriod = 0.1;
if learned
    learned_str = 'learned';
else 
    learned_str = 'not learned';
end
title_str = [intendedStriosomality ' ' health ' ' learned_str];

fluorRewardTrials = cell(1,3);
fluorCostTrials = cell(1,3);
for m = 1:length(miceIDs)
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
    
    [baselineLearningRewardTrace,baselineLearningCostTrace,learningRewardTrace,...
        learningCostTrace,postLearningRewardTrace,postLearningCostTrace] = ...
        photometryPerMouseLearning(twdb,miceIDs{m},miceTrials{m},miceFluorTrials{m},...
        rewardTones(m),costTones(m),firstLearningPeriod);
    
    learningPeriod = 1;
    fluorRewardTrials{ageIdx,learningPeriod} = [fluorRewardTrials{ageIdx,learningPeriod}; baselineLearningRewardTrace];
    fluorCostTrials{ageIdx,learningPeriod} = [fluorCostTrials{ageIdx,learningPeriod}; baselineLearningCostTrace];
    
    learningPeriod = 2;
    fluorRewardTrials{ageIdx,learningPeriod} = [fluorRewardTrials{ageIdx,learningPeriod}; learningRewardTrace];
    fluorCostTrials{ageIdx,learningPeriod} = [fluorCostTrials{ageIdx,learningPeriod}; learningCostTrace];
    
    learningPeriod = 3;
    fluorRewardTrials{ageIdx,learningPeriod} = [fluorRewardTrials{ageIdx,learningPeriod}; postLearningRewardTrace];
    fluorCostTrials{ageIdx,learningPeriod} = [fluorCostTrials{ageIdx,learningPeriod}; postLearningCostTrace];
    
end

numAges = size(fluorRewardTrials,1);
numPeriods = size(fluorRewardTrials,2);
periodStr = {['First ' num2str(100*firstLearningPeriod) '% of learning'],'Rest of learning','Post learning'};

figure('units','normalized','outerposition',[0 0 1 1])
for n = 1:numAges
    for learningPeriod = 1:numPeriods
        subplot(numAges,numPeriods,(n-1)*numPeriods + learningPeriod)
        hold on;
        plot(1:98,ones(1,98)*0.5,'k--')
        plot(1:98,ones(1,98)*0,'k--')
        plot(1:98,ones(1,98)*-0.5,'k--')
        plotPhotometryTraces(fluorRewardTrials{n,learningPeriod},fluorCostTrials{n,learningPeriod})
        numAnimals = sum(~sum(isnan(fluorRewardTrials{n,learningPeriod}),2));
        title({['n=',num2str(numAnimals)],periodStr{learningPeriod}})
    end
    
end
supertitle({title_str,'',''})