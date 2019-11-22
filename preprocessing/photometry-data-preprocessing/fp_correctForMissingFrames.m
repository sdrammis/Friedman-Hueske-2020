function  [filteredImageStackValues,imageStackTimestamps]=fp_correctForMissingFrames(filteredImageStackValues,imageStackTimestamps)

%% TO TEST THE FUNCTION, I SIMULATE MISSING FRAMES BY REMOVING SOME FROM THE IMAGESTACK
% filteredImageStackValues=filteredImageStackValuesBackUp;imageStackTimestamps=imageStackTimestampsBackUp;
% iToRemove=[10 11 15 17 50 51 52 53];
% filteredImageStackValues(iToRemove,:)=[];imageStackTimestamps(iToRemove)=[];

samplingRate_Hz=1/median(diff(imageStackTimestamps));
timeBetweenTwoFrames=1/samplingRate_Hz;

nFibers=size(filteredImageStackValues(:,:,1),2);
emptyFrame=nan(1,nFibers);
diff_Ts=diff(imageStackTimestamps);

%% To detect missing frame and replace them by empty frames
% 1. we calculate the time between each frame.
% 2. we divide this time by a little bit less than the median between two frames
% 3. we take the quotient (floor) and we remove one
% 4. this give us the number of empty frames to insert to keep the sequence of frame synchrone

detectFrameToAdd=floor(diff_Ts/(timeBetweenTwoFrames*0.95));
detectFrameToAdd=detectFrameToAdd-1;
nCorrections=sum(detectFrameToAdd);
insertionPoints=find(detectFrameToAdd>0);
nInsertionPoints = size(insertionPoints,1);
detectFrameToAdd=detectFrameToAdd(insertionPoints);

textColor=[1,0.5,0.25];
msg=sprintf('we detected %d missing frames and %d insertion points',nCorrections,nInsertionPoints);
cprintf(textColor,['\t\t' msg '\n']);

if nInsertionPoints
    for i=1:nInsertionPoints
        a=filteredImageStackValues(1:insertionPoints(i),:);
        b=nan(detectFrameToAdd(i),nFibers);
        c=filteredImageStackValues(insertionPoints(i)+1:end,:);
        filteredImageStackValues=[a;b;c];
        tsToAdd=[];
        for j=1:detectFrameToAdd(i)
            tsToAdd=[tsToAdd ; (imageStackTimestamps(insertionPoints(i))+(j*timeBetweenTwoFrames))];
        end
        imageStackTimestamps=[imageStackTimestamps(1:insertionPoints(i)) ; tsToAdd ; imageStackTimestamps(insertionPoints(i)+1:end)];
        insertionPoints=insertionPoints+detectFrameToAdd(i);
    end
end
msg=sprintf('Empty frames were inserted to replace missing frames');
cprintf(textColor,['\t\t' msg '\n']);

