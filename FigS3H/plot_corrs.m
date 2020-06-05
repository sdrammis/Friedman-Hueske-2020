function plot_corrs(mouse_info,cellType)

[R_bucket_1,R_bucket_2,R_bucket_3,slope_bucket_1,slope_bucket_2,slope_bucket_3 ] = final_corrs(mouse_info,cellType);

figure
subplot(3,1,1)
mean_1 = mean(R_bucket_1);
serr_1 = std(R_bucket_1)/sqrt(length(R_bucket_1));
bar(mean_1);
hold on
errorbar(1,mean_1,serr_1)
scatter(ones(length(R_bucket_1),1),R_bucket_1);
title({cellType,['Low Engagement R Values (0%-33%)']})
ylim([-1 1])

subplot(3,1,2)
mean_2 = mean(R_bucket_2);
serr_2 = std(R_bucket_2)/sqrt(length(R_bucket_2));
bar(mean_2);
hold on
errorbar(1,mean_2,serr_2)
scatter(ones(length(R_bucket_2),1),R_bucket_2);
title(['Mid Engagement R Values (33%-67%)'])
ylim([-1 1])

subplot(3,1,3)
mean_3 = mean(R_bucket_3);
serr_3 = std(R_bucket_3)/sqrt(length(R_bucket_3));
bar(mean_3);
hold on
errorbar(1,mean_3,serr_3)
scatter(ones(length(R_bucket_3),1),R_bucket_3);
title(['High Engagement R Values (67%-100%)'])
ylim([-1 1])

% figure
% subplot(3,1,1)
% sl_mean_1 = mean(slope_bucket_1);
% sl_serr_1 = std(slope_bucket_1)/sqrt(length(slope_bucket_1));
% bar(sl_mean_1);
% hold on
% errorbar(1,sl_mean_1,sl_serr_1)
% scatter(ones(length(slope_bucket_1),1),slope_bucket_1);
% title({cellType,['Low Engagement Slopes (0%-33%)']})
% ylim([-5 7])
% 
% subplot(3,1,2)
% sl_mean_2 = mean(slope_bucket_2);
% sl_serr_2 = std(slope_bucket_2)/sqrt(length(slope_bucket_2));
% bar(sl_mean_2);
% hold on
% errorbar(1,sl_mean_2,sl_serr_2);
% scatter(ones(length(slope_bucket_2),1),slope_bucket_2);
% title(['Mid Engagement Slopes (33%-67%)'])
% ylim([-5 7])
% 
% subplot(3,1,3)
% sl_mean_3 = mean(slope_bucket_3);
% sl_serr_3 = std(slope_bucket_3)/sqrt(length(slope_bucket_3));
% bar(sl_mean_3);
% hold on
% errorbar(1,sl_mean_3,sl_serr_3);
% scatter(ones(length(slope_bucket_3),1),slope_bucket_3);
% title(['High Engagement Slopes (67%-100%)'])
% ylim([-5 7])