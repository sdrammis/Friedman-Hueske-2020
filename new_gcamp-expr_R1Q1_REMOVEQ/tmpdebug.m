% figure;
% subplot(2,2,1);
% imshow(striodilated);
% subplot(2,2,2);
% imshow(matrixsubed);
% subplot(2,2,3);
% imshow(striomask);
% subplot(2,2,4);
% imshow(msndata.cells);

STRIO_IMG = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES/experiment 1/alexander63xstriosomesfirstcohort2018-08-25 18-50 f-2783_slice1_strio.tiff';
matrixMaskColored = cat(3, matrixsubed*1, matrixsubed*0, matrixsubed*1);


figure;
imshow(imreadvisible(STRIO_IMG));
hold on;
h = imshow(matrixMaskColored);
boundaries = bwboundaries(msndata.cells);
for k=1:length(boundaries)
   b = boundaries{k};
   plot(b(:,2),b(:,1),'g','LineWidth',3);
end
hold off;
set(h, 'AlphaData', 0.3);
