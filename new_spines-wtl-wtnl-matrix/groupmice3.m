function [groups, names] = groupmice3(micedb, striosomality)
names = {'WTL', 'WTNL', 'HD'};
groups = {{}, {}, {}};

mice = micedb(strcmp({micedb.intendedStriosomality}, striosomality));
for iMice=1:length(mice)
   mouse = mice(iMice);
   if isempty(mouse.perfusionDate) % Only count histology mice
       continue;
   end
   
   health = mouse.Health;
   
   group = 0;
   if strcmp(health, 'WT')
       if mouse.learnedFirstTask >= 1 
            group = 1;
       else
           group = 2;
       end
   elseif strcmp(health, 'HD')
       group = 3;
   end
   if group > 0 
       groups{group}{end+1} = mouse;
   end
end
end

