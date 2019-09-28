function [groups, names] = groupmice(micedb, striosomality)
names = {'WTL', 'WTNL', 'HDNL'};
groups = {{}, {}, {}};

mice = micedb(strcmp({micedb.intendedStriosomality}, striosomality));
for iMice=1:length(mice)
   mouse = mice(iMice);
   if isempty(mouse.perfusionDate) % Only count histology mice
       continue;
   end
   
   learned = ~isempty(mouse.learnedFirstTask) && mouse.learnedFirstTask > 0;
   health = mouse.Health;
   
   group = 0;
   if strcmp(health, 'WT') && learned
       group = 1;
   elseif strcmp(health, 'WT') && ~learned
       group = 2;
   elseif strcmp(health, 'HD') && ~learned
       group = 3;
   end
   if group > 0 
       groups{group}{end+1} = mouse;
   end
end
end
