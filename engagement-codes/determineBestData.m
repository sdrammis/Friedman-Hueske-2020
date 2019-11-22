function determineBestData(mouseEngagementDir)

moveConvergedAnimals(mouseEngagementDir)

mouseFolders = dir(mouseEngagementDir);
for m = 1:length(mouseFolders)
    mouseFiles = {};
    mouseBICs = [];
    rewardTrials = [];
    if realFile(mouseFolders(m).name)
        mouseID = mouseFolders(m).name;
        engagementFiles = dir([mouseEngagementDir filesep mouseID]);
        for n = 4:length(engagementFiles)
            filename = engagementFiles(n).name;
            if realFile(filename)
                mouseFile = [mouseEngagementDir filesep mouseID filesep filename];
                if isequal(filename,'graphs')
                    continue
                end
                load(mouseFile)
                rewardTrials = [rewardTrials contains(mouseFile,'reward')];
                mouseBICs = [mouseBICs mean(BICs)];
                mouseFiles = [mouseFiles mouseFile];
            end
        end
        if sum(rewardTrials)
            hasReward = logical(rewardTrials);
            [~,I] = min(mouseBICs(hasReward));
            rewardFiles = mouseFiles(hasReward);
            bestFile = rewardFiles{I};
        else
            [~,I] = min(mouseBICs);
            bestFile = mouseFiles{I};
        end
        
        copyfile(bestFile,[mouseEngagementDir, ' Best'])
    end  
end