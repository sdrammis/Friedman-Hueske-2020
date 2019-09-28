conf = config();

dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory');
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory');

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);
miceDREADD = [miceInhbDREADD miceExctDREADD];

for ii=1:length(miceDREADD)
    mouse = miceDREADD(ii);
    mouseID = mouse.ID;
    
    idxs = twdb_lookup(twdb, 'index', 'key', 'mouseID', mouseID);
    for jj=1:length(idxs)
        idx = idxs{jj};

        f = figure;
        hold on
        plot(twdb(idx).raw405Session(end-1000:end,1),twdb(idx).raw405Session(end-1000:end,2),'m')
        plot(twdb(idx).raw470Session(end-1000:end,1),twdb(idx).raw470Session(end-1000:end,2),'b')
        title([mouseID,' IDX: ' num2str(idx)])
        d = ['tmp' filesep 'm' mouseID '-zoom'];
        mkdir(d);
        saveas(f, [d filesep 'idx' num2str(idx) '.png']);
        close all;
    end
end
