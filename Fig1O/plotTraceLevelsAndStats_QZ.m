% Author: QZ
% 08/01/2019
function plotTraceLevelsAndStats_QZ(cTrace3,cTrace2,cTrace1,cTrace0,rTrace0,...
    rTrace1,rTrace2,rTrace3,mouseInfo)
figure()
subplot(1,2,1)
hold on
plotNoBar({cTrace3,cTrace2,cTrace1,cTrace0,rTrace0,rTrace1,rTrace2,rTrace3},...
    'Trace Sum',{'Cost Trace 3','Cost Trace 2','Cost Trace 1','Cost Trace 0',...
    'Reward Trace 0','Reward Trace 1','Reward Trace 2','Reward Trace 3'},...
    [mouseInfo ' Mice Traces at Different Levels'],'r','b','b',1);
hold off
subplot(1,2,2)
hold on
plotNoBar({rTrace3-cTrace3,rTrace2-cTrace2,rTrace1-cTrace1,rTrace0-cTrace0},...
    'R-C Trace Area',{'Level 3','Level 2','Level 1','Level 0'},...
    [mouseInfo ' Mice R-C Traces at Different Levels'],'r','b','b',1);
hold off
% Statistical tests
disp(['>>>>>>>>>' mouseInfo '<<<<<<<<<']);
disp('---------Within Cost Traces---------')
ttest_QZ(cTrace3,cTrace2,'Cost 3 vs. 2: ');
ttest_QZ(cTrace3,cTrace1,'Cost 3 vs. 1: ');
ttest_QZ(cTrace3,cTrace0,'Cost 3 vs. 0: ');
ttest_QZ(cTrace2,cTrace1,'Cost 2 vs. 1: ');
ttest_QZ(cTrace2,cTrace0,'Cost 2 vs. 0: ');
ttest_QZ(cTrace1,cTrace0,'Cost 1 vs. 0: ');
disp('---------Within Reward Traces---------')
ttest_QZ(rTrace3,rTrace2,'Reward 3 vs. 2: ');
ttest_QZ(rTrace3,rTrace1,'Reward 3 vs. 1: ');
ttest_QZ(rTrace3,rTrace0,'Reward 3 vs. 0: ');
ttest_QZ(rTrace2,rTrace1,'Reward 2 vs. 1: ');
ttest_QZ(rTrace2,rTrace0,'Reward 2 vs. 0: ');
ttest_QZ(rTrace1,rTrace0,'Reward 1 vs. 0: ');
disp('---------Between Reward and Cost---------')
ttest_QZ(rTrace3,cTrace3,'Reward vs. Cost 3: ');
ttest_QZ(rTrace2,cTrace2,'Reward vs. Cost 2: ');
ttest_QZ(rTrace1,cTrace1,'Reward vs. Cost 1: ');
ttest_QZ(rTrace0,cTrace0,'Reward vs. Cost 0: ');
disp('---------Reward Minus Cost---------')
ttest_QZ(rTrace3-cTrace3,rTrace2-cTrace2,'R-C 3 vs. 2: ');
ttest_QZ(rTrace2-cTrace2,rTrace1-cTrace1,'R-C 2 vs. 1: ');
ttest_QZ(rTrace1-cTrace1,rTrace0-cTrace0,'R-C 1 vs. 0: ');
ttest_QZ(rTrace3-cTrace3,rTrace1-cTrace1,'R-C 3 vs. 1: ');
ttest_QZ(rTrace3-cTrace3,rTrace0-cTrace0,'R-C 3 vs. 0: ');
ttest_QZ(rTrace2-cTrace2,rTrace0-cTrace0,'R-C 2 vs. 0: ');
disp('---------Compare Mean to 0---------')
ttest_QZ(cTrace3,[],'Cost Level 3 Mean to 0: ');
ttest_QZ(cTrace2,[],'Cost Level 2 Mean to 0: ');
ttest_QZ(cTrace1,[],'Cost Level 1 Mean to 0: ');
ttest_QZ(cTrace0,[],'Cost Level 0 Mean to 0: ');
ttest_QZ(rTrace3,[],'Reward Level 3 Mean to 0: ');
ttest_QZ(rTrace2,[],'Reward Level 2 Mean to 0: ');
ttest_QZ(rTrace1,[],'Reward Level 1 Mean to 0: ');
ttest_QZ(rTrace0,[],'Reward Level 0 Mean to 0: ');
end