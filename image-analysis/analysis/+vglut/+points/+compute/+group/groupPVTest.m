function [groups, names] = groupPVTest(micedb, striosomality)
names = {'WT', 'HD'};
groups = {{}, {}};

miceMatrixWT = {'3002', '3004', '24', '20'};
miceStrioWT = {'57', '45', '53', '2660'};
miceMatrixHD = {'2833', '2803', '2745', '2740'};
miceStrioHD = {'2791', '2784', '65', '2783'};

miceWT = [miceMatrixWT miceStrioWT];
miceHD = [miceMatrixHD miceStrioHD];

mice = micedb(strcmp({micedb.intendedStriosomality}, striosomality));
for iMice=1:length(mice)
   mouse = mice(iMice);
   if isempty(mouse.perfusionDate) % Only count histology mice
       continue;
   end
   
   if any(strcmp(miceWT, mouse.ID))
      groups{1}{end+1} = mouse;
   elseif any(strcmp(miceHD, mouse.ID))
       groups{2}{end+1} = mouse;
   end
end
end
