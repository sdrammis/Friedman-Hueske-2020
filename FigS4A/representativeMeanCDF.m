function representativeMeanCDF(twdb,health)


engaged = 0;
maxLicks = 7;
licks = 0:maxLicks;

figure

taskReversal = 0;

[wtCDF1, wtCDF2] = healthCDF(twdb,health,taskReversal,engaged,[1 2],0,{});

subplot(2,2,1)
hold on
plot(licks,mean(wtCDF1))
plot(licks,mean(wtCDF2))
errorbar(licks,mean(wtCDF1),std_error(wtCDF1),'.b')
errorbar(licks,mean(wtCDF2),std_error(wtCDF2),'.r')
ylim([0 1])
xlabel('Number of Licks')
ylabel('CDF')
title({[health ' Mice First 2 Sessions CDF'],['Discrimination Task n=' num2str(size(wtCDF1,1))]})
legend('Reward Tone','Cost Tone')


[wtCDF1, wtCDF2] = healthCDF(twdb,health,taskReversal,engaged,[1 0],1,{});

subplot(2,2,2)
hold on
plot(licks,mean(wtCDF1))
plot(licks,mean(wtCDF2))
errorbar(licks,mean(wtCDF1),std_error(wtCDF1),'.b')
errorbar(licks,mean(wtCDF2),std_error(wtCDF2),'.r')
ylim([0 1])
xlabel('Number of Licks')
ylabel('CDF')
title({[health ' Mice Last 2 Sessions CDF'],['Discrimination Task n=' num2str(size(wtCDF1,1))]})
legend('Reward Tone','Cost Tone')

taskReversal = 1;

[wtCDF1, wtCDF2] = healthCDF(twdb,health,taskReversal,engaged,[1 2],0,{});

subplot(2,2,3)
hold on
plot(licks,mean(wtCDF1))
plot(licks,mean(wtCDF2))
errorbar(licks,mean(wtCDF1),std_error(wtCDF1),'.b')
errorbar(licks,mean(wtCDF2),std_error(wtCDF2),'.r')
ylim([0 1])
xlabel('Number of Licks')
ylabel('CDF')
title({[health ' Mice First 2 Sessions CDF'],['Reversal Task n=' num2str(size(wtCDF1,1))]})
legend('Reward Tone','Cost Tone')


[wtCDF1, wtCDF2] = healthCDF(twdb,health,taskReversal,engaged,[1 0],1,{});

subplot(2,2,4)
hold on
plot(licks,mean(wtCDF1))
plot(licks,mean(wtCDF2))
errorbar(licks,mean(wtCDF1),std_error(wtCDF1),'.b')
errorbar(licks,mean(wtCDF2),std_error(wtCDF2),'.r')
ylim([0 1])
xlabel('Number of Licks')
ylabel('CDF')
title({[health ' Mice Last 2 Sessions CDF'],['Reversal Task n=' num2str(size(wtCDF1,1))]})
legend('Reward Tone','Cost Tone')

