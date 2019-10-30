function correlateEngagementPupilSize(twdb,fieldname,miceIds)

engaged_zscores_tone1 = nan(length(miceIds),8);
nonEngaged_zscores_tone1 = nan(length(miceIds),8);
engaged_zscores_tone2 = nan(length(miceIds),8);
nonEngaged_zscores_tone2 = nan(length(miceIds),8);
for n = 1:length(miceIds)
    [mouse_engaged_tone1,mouse_nonEngaged_tone1,mouse_engaged_tone2,mouse_nonEngaged_tone2]...
        = correlateEngagementPupilSize_mouse(twdb,miceIds{n},fieldname);
    engaged_zscores_tone1(n,1:length(mouse_engaged_tone1)) = mouse_engaged_tone1;
    nonEngaged_zscores_tone1(n,1:length(mouse_nonEngaged_tone1)) = mouse_nonEngaged_tone1;
    engaged_zscores_tone2(n,1:length(mouse_engaged_tone2)) = mouse_engaged_tone2;
    nonEngaged_zscores_tone2(n,1:length(mouse_nonEngaged_tone2)) = mouse_nonEngaged_tone2;
end

mean_engaged_tone1 = nanmean(engaged_zscores_tone1,2);
st_err_engaged_tone1 = std_error(engaged_zscores_tone1');

mean_nonEngaged_tone1 = nanmean(nonEngaged_zscores_tone1,2);
st_err_nonEngaged_tone1 = std_error(nonEngaged_zscores_tone1');


mean_engaged_tone2 = nanmean(engaged_zscores_tone2,2);
st_err_engaged_tone2 = std_error(engaged_zscores_tone2');

mean_nonEngaged_tone2 = nanmean(nonEngaged_zscores_tone2,2);
st_err_nonEngaged_tone2 = std_error(nonEngaged_zscores_tone2');

if isequal(fieldname,'Response')
    title_str = ['Response Period'];
elseif isequal(fieldname,'Outcome')
    title_str = 'Outcome Period';
else
    title_str = '';
end

figure
subplot(2,1,1)
hold on
bar(1,mean_engaged_tone1)
bar(2,mean_nonEngaged_tone1)
errorbar(1, mean_engaged_tone1', st_err_engaged_tone1,'.b')
errorbar(2, mean_nonEngaged_tone1', st_err_nonEngaged_tone1,'.r')
for n = 1:length(mean_engaged_tone1)
    [~,p] = ttest2(engaged_zscores_tone1(n,:),nonEngaged_zscores_tone1(n,:));
    text(n-0.1,max([mean_engaged_tone1(n)+st_err_engaged_tone1(n),mean_nonEngaged_tone1(n)+st_err_nonEngaged_tone1(n)])+0.05,['p = ' num2str(p)])
end
legend('Engaged Trials', 'Non-Engaged Trials')
set(gca, 'XTickLabel',miceIds,'XTick',1:length(miceIds))
xlabel('Mouse ID')
ylabel('Mean Z-score of Pupil')
title({'Pupil Size Z-score According to Engagement','Tone 1 Trials',title_str})

subplot(2,1,2)
hold on
bar(1,mean_engaged_tone2)
bar(2,mean_nonEngaged_tone2)
errorbar(1, mean_engaged_tone2', st_err_engaged_tone2,'.b')
errorbar(2, mean_nonEngaged_tone2', st_err_nonEngaged_tone2,'.r')
for n = 1:length(mean_engaged_tone2)
    [~,p] = ttest2(engaged_zscores_tone2(n,:),nonEngaged_zscores_tone2(n,:));
    text(n-0.1,min([mean_engaged_tone2(n)-st_err_engaged_tone2(n),mean_nonEngaged_tone2(n)-st_err_nonEngaged_tone2(n)])-0.05,['p = ' num2str(p)])
end
legend('Engaged Trials', 'Non-Engaged Trials')
set(gca, 'XTickLabel',miceIds,'XTick',1:length(miceIds))
xlabel('Mouse ID')
ylabel('Mean Z-score of Pupil')
title({'Tone 2 Trials',title_str})
hold off
