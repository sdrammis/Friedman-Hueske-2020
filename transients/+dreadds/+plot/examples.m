INH_MOUSE = '263'; 
INH_CNO = 26;
INH_SALINE = 25;
f1 = plot_mouse(twdb, INH_MOUSE, INH_CNO, INH_SALINE);
suptitle(sprintf('Ihibatory Mouse (ID=%s)', INH_MOUSE));
saveas(f1, './tmp/inhb_example.fig');

EXCT_MOUSE = '4097'; 
EXCT_CNO = 48;
EXCT_SALINE = 47;
f2 = plot_mouse(twdb, EXCT_MOUSE, EXCT_CNO, EXCT_SALINE);
suptitle(sprintf('Excitatory Mouse (ID=%s)', EXCT_MOUSE));
saveas(f2, './tmp/exct_example.fig');

close all;

function f = plot_mouse(twdb, mouseID, sessionCNO, sessionSaline)
[nSpikes, sessionTimes, sessions] = dreadds.get_mouse_spikes(twdb, mouseID);
idxCNO = [sessions.sessionNumber] == sessionCNO;
idxSaline = [sessions.sessionNumber] == sessionSaline;
rawCNO = sessions(idxCNO).raw470Session;
rawSaline = sessions(idxSaline).raw470Session;
traceCNO = process(rawCNO(:,1), rawCNO(:,2));
traceSaline = process(rawSaline(:,1), rawSaline(:,2));
spikeRates = nSpikes ./ sessionTimes;

len = 3000;
s = length(traceCNO) * 1/2;
t = s + len;
ymax = max([traceCNO(s:t); traceSaline(s:t)]);

f = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,3,[1,2]);
plot(traceSaline(s:t));
ylim([0 ymax]);
xlabel('Time');
ylabel('Raw Trace 470');
title('Saline');

subplot(2,3,[4,5]);
plot(traceCNO(s:t));
xlabel('Time');
ylabel('Raw Trace 470');
title('CNO');

ylim([0 ymax]);
subplot(2,3,[3,6]);
bar([spikeRates(idxSaline) spikeRates(idxCNO)]);
xticklabels({'Saline', 'CNO'});
title('Session Firing Rates');
end

function fixedTrace = process(ts, trc)
FUNCS = {'poly1', 'poly2', 'exp1', 'exp2'};
func = '';
fitparams = [];
rsquare = 0;
for iFuncs=1:length(FUNCS)
    try
        [fitobject, gof] = fit(ts, trc, FUNCS{iFuncs});
        if gof.rsquare > rsquare
           fitparams = fitobject;
           func = FUNCS{iFuncs};
           rsquare = gof.rsquare;
        end
    catch
        continue;
    end
end
switch func
    case 'poly1'
        fitArray = fitparams.a * ts + fitparams.b;
    case 'poly2'
        fitArray = fitparams.p1 * ts.^2 + fitparams.p2 * ts + fitparams.p3;
    case 'exp1'
        fitArray = fitparams.a * exp(fitparams.b * ts);
    case 'exp2'
        fitArray = fitparams.a * exp(fitparams.b * ts) + fitparams.c * exp(fitparams.d * ts);    
end
fixedTrace = trc - fitArray;
end

