% 07/10/2019
% Author: QZ
% mouseFilter.m
function cases = mouseFilter(twdb,learn,age,health,striosomality,removeNoBasePhot)
cases = unique({twdb(:).mouseID});
if learn == true
    cases1 = unique(twdb_lookup(twdb,'mouseID','grade','learnedFirstTask',0,inf));
    cases = intersect(cases,cases1);
elseif learn == false
    cases1 = unique(twdb_lookup(twdb,'mouseID','key','learnedFirstTask',-1));
    cases = intersect(cases,cases1);
end
if strcmp(age,'Young') % 0-8
    cases2 = unique(twdb_lookup(twdb,'mouseID','grade','firstSessionAge',0,8));
    cases = intersect(cases,cases2);
elseif strcmp(age,'Mid') % 9-12
    cases2 = unique(twdb_lookup(twdb,'mouseID','grade','firstSessionAge',9,12));
    cases = intersect(cases,cases2);
elseif strcmp(age,'Old') % 13+
    cases2 = unique(twdb_lookup(twdb,'mouseID','grade','firstSessionAge',13,inf));
    cases = intersect(cases,cases2);
end
if strcmp(health,'WT')
    cases3 = unique(twdb_lookup(twdb,'mouseID','key','Health','WT'));
    cases = intersect(cases,cases3);
elseif strcmp(health,'HD')
    cases3 = unique(twdb_lookup(twdb,'mouseID','key','Health','HD'));
    cases = intersect(cases,cases3);
end
if strcmp(striosomality,'Strio')
    cases4 = unique(twdb_lookup(twdb,'mouseID','key','intendedStriosomality','Strio'));
    cases = intersect(cases,cases4);
elseif strcmp(striosomality,'Matrix')
    cases4 = unique(twdb_lookup(twdb,'mouseID','key','intendedStriosomality','Matrix'));
    cases = intersect(cases,cases4);
end
if removeNoBasePhot
    cases5 = {'2660','2736','2739','2741','2743','2776','2777','2781',...
        '2782','2783','2785','2786','2788','2789','2790','2795','2802',...
        '2852'};
    cases = setdiff(cases,cases5);
end
end