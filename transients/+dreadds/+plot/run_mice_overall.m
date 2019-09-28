conf = config();

dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory');
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory');

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);
miceDREADD = [miceInhbDREADD miceExctDREADD];

strioWTEx = [];
strioWTInhb = [];
matrixWTEx = [];
matrixWTInhb = [];
strioHDEx = [];
matrixHDEx = [];
mashNegEx = [];
mashNegInhb = [];
for ii=1:length(miceDREADD)
    mouse = miceDREADD(ii);
    [nSpikes, inj, conctr] = dreadds.get_mouse_spikes(twdb, mouse.ID);
    
    idxsCNO = strcmp(inj, 'CNO');
    spikesCNO = nSpikes(idxsCNO);
    contrCNO = conctr(idxsCNO);
    spikesSaline = nSpikes(~idxsCNO);
    
    avgSpikesCNO1 = nanmean(spikesCNO(contrCNO == 0.3));
    avgSpikesCNO2 = nanmean(spikesCNO(contrCNO == 0.6));
    avgSpikesCNO3 = nanmean(spikesCNO(contrCNO == 1));
    avgSpikesSaline = nanmean(spikesSaline);
    

    datum = [avgSpikesCNO1 avgSpikesCNO2 avgSpikesCNO3 avgSpikesSaline];
    
    striosomality = mouse.intendedStriosomality;
    typeDREADD = mouse.DREADDType;
    health = mouse.Health;
    
    if  mouse.positive == 0 && strcmp(mouse.genotype, 'Mash')
        if strcmp(typeDREADD, 'Excitatory')
            mashNegEx = [mashNegEx; datum];
        elseif strcmp(typeDREADD, 'Inhibitory')
            mashNegInhb = [mashNegInhb; datum];
        end
        continue;
    end
    
    if strcmp(health, 'HD') && strcmp(typeDREADD, 'Excitatory')
        if strcmp(striosomality, 'Strio')
            strioHDEx = [strioHDEx; datum];
        elseif strcmp(striosomality, 'Matrix')
            matrixHDEx = [matrixHDEx; datum];
        end
        continue;
    end
    
    if strcmp(health, 'WT')
        if strcmp(striosomality, 'Strio') && strcmp(typeDREADD, 'Excitatory')
            strioWTEx = [strioWTEx; datum];
        elseif strcmp(striosomality, 'Strio') && strcmp(typeDREADD, 'Inhibitory')
            strioWTInhb = [strioWTInhb; datum];
        end
        
        if strcmp(striosomality, 'Matrix') && strcmp(typeDREADD, 'Excitatory')
            matrixWTEx = [matrixWTEx; datum];
        elseif strcmp(striosomality, 'Matrix') && strcmp(typeDREADD, 'Inhibitory')
            matrixWTInhb = [matrixWTInhb; datum];
        end
    end
end

%% Plot
names = {'Strio WT Ex', 'Strio WT Inh', 'Matrix WT Ex', 'Matrix WT Inh', ...
    'Strio HD Ex', 'Matrix HD Ex', 'Mash Neg Ex', 'Mash Neg Inh'};

f = figure;
dat = {
    strioWTEx, ...
    strioWTInhb, ...
    matrixWTEx, ...
    matrixWTInhb, ...
    strioHDEx, ...
    matrixHDEx, ...
    mashNegEx, ...
    mashNegInhb, ...
    };
for k=1:length(dat)
    subplot(4,2,k);
    datum = dat{k};
    [m,n] = size(datum);
    
    hold on;
    b = bar(nanmean(datum));
    scatter(ones(1,m),datum(:,1),'k*');
    scatter(2*ones(1,m),datum(:,2),'k*');
    scatter(3*ones(1,m),datum(:,3),'k*');
    scatter(4*ones(1,m),datum(:,4),'k*');
    
    xticklabels({ 'CNO 0.3', 'CNO 0.6', 'CNO 1', 'Saline' });
    title(names{k});
end
