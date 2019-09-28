OUT_FILE_STRIO = '/Volumes/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_strio.csv';
OUT_FILE_MATRIX = '/Volumes/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_matrix.csv';

load(OUT_FILE_STRIO)
load(OUT_FILE_MATRIX)

figure; 
subplot(2,1,1);
plot_bars({msn_density_strio(:,1), msn_density_strio(:,2), ...
    msn_density_strio(:,3), msn_density_strio(:,4), msn_density_strio(:,5), ...
    msn_density_strio(:,6), msn_density_strio(:,7)}, ...
    {'All', 'TL', 'TM', 'TR', 'BL', 'BM', 'BR'});
title('Strio Density');
subplot(2,1,2);
plot_bars({msn_density_matrix(:,1), msn_density_matrix(:,2), ...
    msn_density_matrix(:,3), msn_density_matrix(:,4), msn_density_matrix(:,5), ...
    msn_density_matrix(:,6), msn_density_matrix(:,7)}, ...
    {'All', 'TL', 'TM', 'TR', 'BL', 'BM', 'BR'});
title('Matrix Density');

figure; 
subplot(2,4,1);
plot_bars({msn_density_strio(:,1), msn_density_matrix(:,1)}, {'Strio', 'Matrix'});
title('All');
subplot(2,4,2);
plot_bars({msn_density_strio(:,2), msn_density_matrix(:,2)}, {'Strio', 'Matrix'});
title('Top Left');
subplot(2,4,3);
plot_bars({msn_density_strio(:,3), msn_density_matrix(:,3)}, {'Strio', 'Matrix'});
title('Top Mid');
subplot(2,4,4);
plot_bars({msn_density_strio(:,4), msn_density_matrix(:,4)}, {'Strio', 'Matrix'});
title('Top Right');
subplot(2,4,5);
plot_bars({msn_density_strio(:,5), msn_density_matrix(:,5)}, {'Strio', 'Matrix'});
title('Bot Left');
subplot(2,4,6);
plot_bars({msn_density_strio(:,6), msn_density_matrix(:,6)}, {'Strio', 'Matrix'});
title('Bot Mid');
subplot(2,4,7);
plot_bars({msn_density_strio(:,7), msn_density_matrix(:,7)}, {'Strio', 'Matrix'});
title('Bot Right');
