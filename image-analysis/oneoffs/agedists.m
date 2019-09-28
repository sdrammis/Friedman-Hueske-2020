idxWTL = strcmp('Strio', {micedb.intendedStriosomality}) & strcmp('WT', {micedb.Health}) & [micedb.learnedFirstTaskSessions] > -1 & ~cellfun(@isempty, {micedb.exids});
idxWTNL = strcmp('Strio', {micedb.intendedStriosomality}) & strcmp('WT', {micedb.Health}) & [micedb.learnedFirstTaskSessions] == -1 & ~cellfun(@isempty, {micedb.exids});
idxWTO = strcmp('Strio', {micedb.intendedStriosomality}) & strcmp('WT', {micedb.Health}) & isnan([micedb.learnedFirstTaskSessions]) & ~cellfun(@isempty, {micedb.exids});

figure;
subplot(2,1,1);
histogram([micedb(idxWTL).firstSessionAge]);
title('Learned');
subplot(2,1,2);
histogram([micedb(idxWTNL).firstSessionAge]);
title('Not Learned');
sgtitle('Strio WT -- First Session Age');

perfageWTL = cellfun(@getperfage, num2cell(micedb(idxWTL)));
perfageWTNL = cellfun(@getperfage, num2cell(micedb(idxWTNL)));

figure;
subplot(2,1,1);
histogram(perfageWTL);
title('Learned');
subplot(2,1,2);
histogram(perfageWTNL);
title('Not Learned');
sgtitle('Strio WT -- Perferation Date Age');


function age = getperfage(mouse)
birthDate = datetime(mouse.birthDate, 'InputFormat', 'yyyy-MM-dd');
perfDate = datetime(mouse.perfusionDate, 'Inputformat', 'yy/MM/dd');
age = calmonths(caldiff([birthDate, perfDate], 'months'));
end
