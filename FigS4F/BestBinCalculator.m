%Kaden DiMarco 6/13/19
%Calculats average percent time spent in light during each bin (5 minute intervals) 

Bin1 = [];
Bin2 = [];
Bin3 = [];
Bin4 = [];
Bin5 = [];
Bin6 = [];
Bin7 = [];
Bin8 = [];
Bin9 = [];
Bin10 = [];
Bin11 = [];
Bin12 = [];
Bin13 = [];
Bin14 = [];
Bin15 = [];



for i = 1:length(twdb)
    LightAversion = twdb(i).LightAversion;
    if isempty(LightAversion)
        continue
    end
    
    
    for m = 1:height(LightAversion)
        if LightAversion.LIGHT_LEVEL(m) ~= 400
            continue
        end
        %Bin1
        if LightAversion.POINT(m) == 1
            Bin1 = [Bin1, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin2
        if LightAversion.POINT(m) == 2
            Bin2 = [Bin2, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin3
        if LightAversion.POINT(m) == 3
            Bin3 = [Bin3, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin4
        if LightAversion.POINT(m) == 4
            Bin4 = [Bin4, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin5
        if LightAversion.POINT(m) == 5
            Bin5 = [Bin5, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin6
        if LightAversion.POINT(m) == 6
            Bin6 = [Bin6, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin7
        if LightAversion.POINT(m) == 7
            Bin7 = [Bin7, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin8
        if LightAversion.POINT(m) == 8
            Bin8 = [Bin8, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin9
        if LightAversion.POINT(m) == 9
            Bin9 = [Bin9, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin10
        if LightAversion.POINT(m) == 10
            Bin10 = [Bin10, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin11
        if LightAversion.POINT(m) == 11
            Bin11 = [Bin11, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin12
        if LightAversion.POINT(m) == 12
            Bin12 = [Bin12, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin13
        if LightAversion.POINT(m) == 13
            Bin13 = [Bin13, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin14
        if LightAversion.POINT(m) == 14
            Bin14 = [Bin14, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
        %Bin15
        if LightAversion.POINT(m) == 15
            Bin15 = [Bin15, LightAversion.Light_Time(m)/(LightAversion.Light_Time(m)...
                + LightAversion.Dark_Time(m))];
        end
    end
end

%goal is to find time where mice have spent on average most time in the light

%adds all data collected up to each bin

UpToBin1 = [Bin1];
UpToBin2 = [Bin1, Bin2];
UpToBin3 = [Bin1, Bin2, Bin3];
UpToBin4 = [Bin1, Bin2, Bin3, Bin4];
UpToBin5 = [Bin1, Bin2, Bin3, Bin4, Bin5];
UpToBin6 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6];
UpToBin7 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7];
UpToBin8 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8];
UpToBin9 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9];
UpToBin10 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10];
UpToBin11 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11];
UpToBin12 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12];
UpToBin13 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13];
UpToBin14 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13, Bin14];
UpToBin15 = [Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13, Bin14, Bin15];

%UpToBin contains percent time spent in light, DarkUpTobin contains percent
%time spent in dark

%DarkUpToBin1 = 1 - UpToBin1;
%DarkUpToBin2 = 1 - UpToBin2;
%DarkUpToBin3 = 1 - UpToBin3;
%DarkUpToBin4 = 1 - UpToBin4;
%DarkUpToBin5 = 1 - UpToBin5;
%DarkUpToBin6 = 1 - UpToBin6;
%DarkUpToBin7 = 1 - UpToBin7;
%DarkUpToBin8 = 1 - UpToBin8;
%DarkUpToBin9 = 1 - UpToBin9;
%DarkUpToBin10 = 1 - UpToBin10;
%DarkUpToBin11 = 1 - UpToBin11;
%%DarkUpToBin12 = 1 - UpToBin12;
%DarkUpToBin13 = 1 - UpToBin13;
%DarkUpToBin14 = 1 - UpToBin14;
%DarkUpToBin15 = 1 - UpToBin15;

%average time spent in light up to each bin for all animals

average1 = mean(UpToBin1);
average2 = mean(UpToBin2);
average3 = mean(UpToBin3);
average4 = mean(UpToBin4);
average5 = mean(UpToBin5);
average6 = mean(UpToBin6);
average7 = mean(UpToBin7);
average8 = mean(UpToBin8);
average9 = mean(UpToBin9);
average10 = mean(UpToBin10);
average11 = mean(UpToBin11);
average12 = mean(UpToBin12);
average13 = mean(UpToBin13);
average14 = mean(UpToBin14);
average15 = mean(UpToBin15);

%error bars

%average time spent in light at each timestamp for each animal

AvgArray1 = (Bin1);
AvgArray2 = (Bin1 + Bin2)/2;
AvgArray3 = (Bin1 + Bin2 + Bin3)/3;
AvgArray4 = (Bin1 + Bin2 + Bin3 + Bin4)/4;
AvgArray5 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5)/5;
AvgArray6 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6)/6;
AvgArray7 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7)/7;
AvgArray8 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8)/8;
AvgArray9 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9)/9;
AvgArray10 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10)/10;
AvgArray11 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10 + ...
    Bin11)/11;
AvgArray12 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10 + ...
    Bin11 + Bin12)/12;
AvgArray13 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10 + ...
    Bin11 + Bin12 + Bin13)/13;
AvgArray14 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10 + ...
    Bin11 + Bin12 + Bin13 + Bin14)/14;
AvgArray15 = (Bin1 + Bin2 + Bin3 + Bin4 + Bin5 + Bin6 + Bin7 + Bin8 + Bin9 + Bin10 + ...
    Bin11 + Bin12 + Bin13 + Bin14 + Bin15)/15;

%average time spent in dark up to each bin for each animal

DarkAvgArray1 = 1 - AvgArray1;
DarkAvgArray2 = 1 - AvgArray2;
DarkAvgArray3 = 1 - AvgArray3;
DarkAvgArray4 = 1 - AvgArray4;
DarkAvgArray5 = 1 - AvgArray5;
DarkAvgArray6 = 1 - AvgArray6;
DarkAvgArray7 = 1 - AvgArray7;
DarkAvgArray8 = 1 - AvgArray8;
DarkAvgArray9 = 1 - AvgArray9;
DarkAvgArray10 = 1 - AvgArray10;
DarkAvgArray11 = 1 - AvgArray11;
DarkAvgArray12 = 1 - AvgArray12;
DarkAvgArray13 = 1 - AvgArray13;
DarkAvgArray14 = 1 - AvgArray14;
DarkAvgArray15 = 1 - AvgArray15;


SE1 = calcSE(AvgArray1);
SE2 = calcSE(AvgArray2);
SE3 = calcSE(AvgArray3);
SE4 = calcSE(AvgArray4);
SE5 = calcSE(AvgArray5);
SE6 = calcSE(AvgArray6);
SE7 = calcSE(AvgArray7);
SE8 = calcSE(AvgArray8);
SE9 = calcSE(AvgArray9);
SE10 = calcSE(AvgArray10);
SE11 = calcSE(AvgArray11);
SE12 = calcSE(AvgArray12);
SE13 = calcSE(AvgArray13);
SE14 = calcSE(AvgArray14);
SE15 = calcSE(AvgArray15);


%plot data

err = [SE1, SE2, SE3, SE4, SE5, SE6, SE7, SE8, SE9, SE10, SE11, SE12, SE13, SE14, SE15];
y = [average1, average2, average3, average4, average5, average6, average7, average8, average9,...
    average10, average11, average12, average13, average14, average15];



plot((1:15), y);
%set(gca,'XTickLabel','Bins','XTick',1:15);

title('Average Percent Time Mice Spent in Light versus Time');
ylabel('Average Percent Time in Light');
xlabel('Bins');
hold on;
errorbar(y,err,'k','linestyle','none');
hold off;

%significance of UpToBin

ttest_QZ(AvgArray1, DarkAvgArray1, 'Percent time in light up to bin1 significance');
ttest_QZ(AvgArray2, DarkAvgArray2, 'Percent time in light up to bin2 significance');
ttest_QZ(AvgArray3, DarkAvgArray3, 'Percent time in light up to bin3 significance');
ttest_QZ(AvgArray4, DarkAvgArray4, 'Percent time in light up to bin4 significance');
ttest_QZ(AvgArray5, DarkAvgArray5, 'Percent time in light up to bin5 significance');
ttest_QZ(AvgArray6, DarkAvgArray6, 'Percent time in light up to bin6 significance');
ttest_QZ(AvgArray7, DarkAvgArray7, 'Percent time in light up to bin7 significance');
ttest_QZ(AvgArray8, DarkAvgArray8, 'Percent time in light up to bin8 significance');
ttest_QZ(AvgArray9, DarkAvgArray9, 'Percent time in light up to bin9 significance');
ttest_QZ(AvgArray10, DarkAvgArray10, 'Percent time in light up to bin10 significance');
ttest_QZ(AvgArray11, DarkAvgArray11, 'Percent time in light up to bin11 significance');
ttest_QZ(AvgArray12, DarkAvgArray12, 'Percent time in light up to bin12 significance');
ttest_QZ(AvgArray13, DarkAvgArray13, 'Percent time in light up to bin13 significance');
ttest_QZ(AvgArray14, DarkAvgArray14, 'Percent time in light up to bin14 significance');
ttest_QZ(AvgArray15, DarkAvgArray15, 'Percent time in light up to bin15 significance');

