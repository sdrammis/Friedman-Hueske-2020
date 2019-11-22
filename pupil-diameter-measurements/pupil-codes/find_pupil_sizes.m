function[size_array]=find_pupil_sizes(folder_path,base_name,store)
%Main function uses helper functions pupil_size_alg and error_correction
%returns array with pupil sizes and eccentricties
%%specify directory
%%base_name is the base name with which to save images, if store =1 it will save
%%the images and show the pupil finding process
%% s specifies wether or not you want to save the image/display it
srcFiles=dir(strcat(folder_path,'\*.jpg'));
srcFiles;
%% Run pupil finder
pupil={};
for i = 1 : length(srcFiles)
    try
    filename = strcat(srcFiles(i).folder,'\',srcFiles(i).name);
    [s,ecc]=pupil_size_alg(filename,char(base_name+string(i)),1,store);
    s1=s;
    e1=ecc;      
    if ~isnan(s1)&& e1<.5  
        [s,ecc]=Error_correction(filename,char(base_name+string(i)),1,9,store);
        if isnan(s)||ecc>e1
            s=s1;
            ecc=e1;
        end
    end
    pupil{i,1}=s;
    pupil{i,2}=ecc;
    %figure, imshow(A{i});
    catch 
        fl='fileerror'
        filename = strcat(srcFiles(i).folder,'\',srcFiles(i).name);
        pupil{i,1}=-1;
        pupil{i,2}=0;
    end

end


 %% Correct errors, Check if nonetypes exist, If no pupil detected will return value of -1 for that image

result=cellfun(@(C) isnumeric(C) && any(isnan(C(:))), pupil);
B = all(result(:) ==0);
t=3;
if B ==0
for i = 1 : length(srcFiles)
    if isnan(pupil{i,1})
    filename = strcat(srcFiles(i).folder,'\',srcFiles(i).name);
    s=NaN;
    ecc1=1;
    while isnan(s)
    temp=ecc1;
    %t is the offset we will increase to iterativley threshold the
    %problematic images,if the eccentricity doesn't get better with an
    %iteration we mark that image as unidentifiable (probably due to closed
    %eye)
    [s,ecy]=Error_correction(filename,char(base_name+string(i)),1,t,store);
    if t>24||ecy-temp>.1
        s=-1;
    end
    ecc1=ecy;
    t=t+3;
    end
    [s1,ecc1]=Error_correction(filename,char(base_name+string(i)),1,t+10,store);
        if ecy>ecc1
            s=s1;
            ecy=ecc1;
        end
    pupil{i,1}=s;
    pupil{i,2}=ecy;
    t=3;
    end
end
end

size_array=pupil;

