function [v,t]=fp_reconstructFrameSequence(blue_imageStackValues,blue_imageStackTimestamps,purple_imageStackValues,purple_imageStackTimestamps,iFiber)
x=fp_load_fpData(blue_imageStackValues,blue_imageStackTimestamps,purple_imageStackValues,purple_imageStackTimestamps,iFiber);
v=reshape([x.pV;x.bV],1,size(x.pV,1)+size(x.bV,1));
t=reshape([x.pT;x.bT],1,size(x.pT,1)+size(x.bT,1));
[t,i]=sort(t);
v=v(i);
clear x 

