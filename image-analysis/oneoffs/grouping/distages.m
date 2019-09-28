mouseIDs = {
  '2553', '2734', '2783', '2787', ...
  '2791', '2795', '2745', '2775', ...
  '2826', '2833', '3758', '2610', ...
  '2660', '2703', '2713', '2784', ...
  '2788', '2740', '2803', '2824', ...
  '2830', '2834', '2593', '2594', ...
  '2778', '4947', '2712', '3004', ...
    '57', '2735', '3002', '3762', ...
  '2744', '2831', '2774'
};

sessionsHist = [];
sessionsOther = [];

for iMice=1:length(miceType)
   mouse = miceType(iMice);
   
   isStrio = strcmp(mouse.intendedStriosomality, 'Matrix');
   session = mouse.learnedFirstTaskSessions;
   health = mouse.Health;
   if ~strcmp(health, 'WT') || session == -1 || ~isStrio
      continue; 
   end
   
   if any(strcmp(mouseIDs, mouse.ID))
       sessionsHist(end+1) = session;
   else
       sessionsOther(end+1) = session;
   end 
end

figure; 
hold on;
histogram(sessionsHist);
histogram(sessionsOther);
title('Matrix WT Learned');
legend('Has Histology', 'Other animals');
ylabel('Number of Animals');
xlabel('Session Learned First Task');


