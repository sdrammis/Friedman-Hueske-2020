conf = config();

dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory');
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory');

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);
miceDREADD = [miceInhbDREADD miceExctDREADD];

savedir = [conf.MICE_FIGS filesep 'dreadd_indv_grade=0.55'];
mkdir(savedir);
for ii=1:length(miceDREADD)
    mouse = miceDREADD(ii);
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    try
        [nSpikes, spikeTimes, sessions] = dreadds.get_mouse_spikes(twdb, mouse.ID);
    catch
        fprintf('Mouse %s FAILED!!!\n', mouse.ID);
        continue;
    end
    dreadds.plot.mouse(nSpikes, spikeTimes, sessions)
    title_ = [sprintf('Mouse ID = %s, Health = %s, Striosomality = %s', ...
        mouse.ID, mouse.Health, mouse.intendedStriosomality), ...
        newline sprintf('DREADDType = %s, genotype = %s, positive = %d', ...
        mouse.DREADDType, mouse.genotype, mouse.positive)];
    suptitle(title_);
    saveas(f, [savedir filesep mouse.ID '.png']);
    close all;
end