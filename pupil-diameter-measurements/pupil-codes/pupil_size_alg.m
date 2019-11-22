function [pupil_size,ecy]=pupil_size_alg(frame,fname,pupil,store)
%Francis Edward McCann Ramirez

%%frame is the name of the image, fname is the name of the file to be saved,
%%pupil is a 1 or 0 value indicating wether or not you want to find the
%%eye or the pupil
%the ouutput is an array representing the area of the elipse for each frame
%% load image and sharpen
ecy=1;
pupil_size=0;
loaded=imread(frame);
%remove blue component
loaded(:,:,3) = 0;
original=rgb2gray(loaded);
sharpened =imsharpen(original);
imadjust(sharpened);
new_sharpened=sharpened;

%% Calculate histogram values

%preprocess image
preprocessed=reshape(new_sharpened,1,[]);
preprocessed=double(preprocessed);
smoothed=double(smoothdata(preprocessed));
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
%This sets the minumum threshold, adusting may speed up, at expense of
%poterntiall underfitting pupil if eye closes a lot or session
if threshold<66
    threshold=66;
end
%find values greater than the calculated threshold value
zeros1=sharpened>=threshold;

processed=sharpened;

% find the background and subtract it 
mask = ones(size(original));
mask=mask*0;
mask(25:end-25,25:end-25) = 1;
bw = activecontour(original,mask,300);
whites=bw<=0;

%make the calculated background white and invert image for processing
processed(whites)=255;
processed=imadjust(processed);
processed(zeros1)=255;
processed=imsharpen(processed);
processed=imcomplement(processed);
%% display image and find elepsis
imshow(sharpened), title('Original Image C');
new_sharpened=processed;
%if pupil==0
    %new_sharpened=medfilt2(new_sharpened);
%end
%label black and white regions for further processing
[labeledImage, ~] = bwlabel(new_sharpened);

%run elipse finding algorithm
s= regionprops(labeledImage, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid');


imshow(original)
hold on

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);
pupil_size=-1;

%set conditions for filtering out the proper elipse
if pupil==1
minl=7;
maxl=80;
e=0.87;
else
    minl=30;
    maxl=80;
    e=.87;
end

%plot calculated elipse over the original image and save the figure
for k = 1:length(s)
    if s(k).Eccentricity<e && minl<s(k).MajorAxisLength && s(k).MajorAxisLength<maxl
    if pupil==1 || (s(k).Orientation<90 && s(k).Orientation>=0)
    if store ==1
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    original = s(k).MajorAxisLength/2;
    sharpened = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [original*cosphi; sharpened*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
    end
    if s(k).Eccentricity<ecy
    pupil_size=3.14*s(k).MajorAxisLength*s(k).MinorAxisLength;
    ecy=s(k).Eccentricity;
    end
    end
    end
end
if ecy>.5 && pupil==1 && ecy~=1
        final='flagged for error';
        pupil_size=NaN;
        frame;
else
    if store==1
    saveas(gcf,fname,'jpeg');
    end
end
%uncomment to save image

hold off

