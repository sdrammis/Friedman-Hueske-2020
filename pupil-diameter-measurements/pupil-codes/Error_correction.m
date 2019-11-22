function [pupil_size,ecy]=Error_correction(frame,fname,pupil,t,store)
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

%% Calculate histogram values, based on that set threshold?
%Second parameter sets the minumum threshold, adusting may speed up, at expense of
%poterntiall underfitting pupil if eye closes a lot or session
[threshold]=calculate_thresh(new_sharpened,66,1,t);
%find values greater than the calculated threshold value
zeros1=new_sharpened>=threshold;
processed=new_sharpened;

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
%label black and white regions for further processing
[labeledImage, numberOfRegions] = bwlabel(new_sharpened);

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
minl=10;
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
    if store==1 
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
if ecy>.5 && pupil==1 && pupil_size>0
        saveas(gcf,fname,'jpeg');
        final='flagged for error';
        pupil_size=NaN;
        ecy=1;
        %uncomment to print frame name
        %frame
else 
    if store==1
    saveas(gcf,fname,'jpeg');
    end
end 
hold off

