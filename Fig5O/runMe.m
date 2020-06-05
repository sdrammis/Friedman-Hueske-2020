

%load('light_twdb_2020-03-13_spikes.mat')
plotAllDristributions_DREADD(distributionComparison_sessions_DREADD(twdb,'Excitatory','Strio','HD',1,'all'),'Strio Cre(+) HD Excitatory DREADD','c')
plotAllDristributions_DREADD(distributionComparison_sessions_DREADD(twdb,'Excitatory','Strio','HD',0,'all'),'Strio Cre(-) HD Excitatory DREADD','c')
plotAllDristributions_DREADD(distributionComparison_sessions_DREADD(twdb,'mCherry','all','all',1,'all'),'DREADD(-)','c')