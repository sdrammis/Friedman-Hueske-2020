function dreaddBehaviorStatsGivenSpikes_excitatory(twdb,dreaddGroups,miceIDs,intendedStriosomality,health,learned,DREADDType)

goodSpikeIDs = unique(dreaddGroups.MouseID);

if ~isequal(learned,'all')
    if learned
        learned_str = 'learned';
    else 
        learned_str = 'not learned';
    end
else
    learned_str = 'all';
end
title_str = [intendedStriosomality ' ' health ' ' learned_str ' ' DREADDType ' DREADD'];

reversal = 0;

figure
hold on
stat = []; 
diff = [];
used_mice = [];
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    mouseIDNum = str2double(mouseID);
    if ~sum(goodSpikeIDs == mouseIDNum)
        continue
    end
    sessionIdx = get_mouse_sessions(twdb,mouseID,~reversal,1,'all',0); 
    sessionNums = [twdb(sessionIdx).sessionNumber];
    cnoSessions = find(dreaddGroups.MouseID == mouseIDNum);
    
    for s = 1:length(cnoSessions)

        cnoSessionNum = cell2mat(dreaddGroups.SessionNumCNO(cnoSessions(s)));
        cnoSessionIdx = sessionIdx(sessionNums == cnoSessionNum);
        session = twdb(cnoSessionIdx);
        if ~isempty(session.devaluation)
            continue
        end
        cnoConcentration = session.concentration;
  
                
        [rewardTrials,costTrials] = reward_and_cost_trials(session.trialData,[],session.rewardTone,session.costTone);
        [~, ~, ~,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
        cno_val = c;

        salSessionNum = cell2mat(dreaddGroups.SessionNumSaline(cnoSessions(s)));
        salSessionIdx = sessionIdx(sessionNums == salSessionNum);
        session = twdb(salSessionIdx);
        [rewardTrials,costTrials] = reward_and_cost_trials(session.trialData,[],session.rewardTone,session.costTone);
        [~, ~, ~,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,costTrials.ResponseLickFrequency);
        sal_val = c;
                
        stat = [stat cno_val-sal_val];        
        diff = [diff dreaddGroups.SpikeRateDiff(cnoSessions(s))];
        used_mice = [used_mice mouseIDNum];
        plot(diff(end),stat(end),'ko','MarkerFaceColor',[cnoConcentration 0.5 0])    
        text(diff(end),stat(end),mouseID)
    end
    
end

x = diff;
y = stat;
[~,m1,b1]=regression(x,y);
lineRate = 0.000001;
fittedX=(min(x)-lineRate):lineRate:(max(x)+lineRate);
fittedY=fittedX*m1+b1;
plot(fittedX,fittedY,'k','LineWidth',3);
cor1 = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval= P(2);
else
    pval = P;
end
xlabel('Spike Rate Difference of CNO to Saline Session')
ylabel(['CNO c - Saline c'])
title(['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval)])

h = zeros(3,1);
h(1) = plot(NaN,NaN,'ko','MarkerFaceColor',[1 0.5 0]);
h(2) = plot(NaN,NaN,'ko','MarkerFaceColor',[0.6 0.5 0]);
h(3) = plot(NaN,NaN,'ko','MarkerFaceColor',[0.3 0.5 0]);
legend(h, 'CNO 1', 'CNO 0.6', 'CNO 0.3');

supertitle({[title_str ' mouse  ' num2str(miceIDs{1})],''})

end