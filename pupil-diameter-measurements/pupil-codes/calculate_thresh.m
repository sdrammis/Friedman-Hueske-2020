function [threshhold]=calculate_thresh(image,thresh,pupil,offset)

data=reshape(image,1,[]);
data=double(data);
smoothed=double(smoothdata(data));
smoothed=smoothdata(smoothed);
bins=double(linspace(0,255,50));

%create histogram and find threshhold
h=hist(smoothed,bins);
threshholds=islocalmin(h(1:30),'MaxNumExtrema',1);
flag=1;
for i=1:30
    if flag==1 && threshholds(1,i)==1  && i>5
        value=i;
        flag=0;
    end
end
if flag==1
    i=27;
end
%if pupil is one find pupil, else find the eye threshold based on the value
%of this property

if pupil==1
threshold=255*(value)/50-43;
else
threshold=255*(value)/50+27;
end

if threshold<thresh
    threshold=thresh;
end
threshhold=threshold-offset;