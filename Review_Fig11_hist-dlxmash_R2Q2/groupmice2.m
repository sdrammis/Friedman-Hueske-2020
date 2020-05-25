function [groups, names] = groupmice2(micedb, striosomality, genotype)
names = {'WT', 'HD'};
groups = {{}, {}};

mice = micedb(...
    strcmp({micedb.intendedStriosomality}, striosomality) ...
    & strcmp({micedb.genotype}, genotype));
for iMice=1:length(mice)
   mouse = mice(iMice);
   if isempty(mouse.perfusionDate) % Only count histology mice
       continue;
   end
   
   health = mouse.Health;
   
   group = 0;
   if strcmp(health, 'WT')
       group = 1;
   elseif strcmp(health, 'HD')
       group = 2;
   end
   if group > 0 
       groups{group}{end+1} = mouse;
   end
end
end

