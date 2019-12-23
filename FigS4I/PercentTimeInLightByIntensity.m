function PercentTimeInLightByIntensity(twdb)

%Kaden DiMarco 6/13/19
%Calculates average percent time spent in light during each bin (5 minute intervals) 
%per animal

WTmice = cell2mat(twdb_lookup(twdb, 'index', 'key', 'Health', 'WT'));
HDmice = cell2mat(twdb_lookup(twdb, 'index', 'key', 'Health', 'HD'));

WTFilteredYng = [];
WTFilteredMid = [];
WTFilteredOld = [];
HDFilteredYng = [];
HDFilteredMid = [];
HDFilteredOld = [];

WTdata4Luz = {};
HDdata4Luz = {};
WTdata40Luz = {};
HDdata40Luz = {};
WTdata400Luz = {};
HDdata400Luz = {};

WTdata4LuzPerMouse = [];
HDdata4LuzPerMouse = [];
WTdata40LuzPerMouse = [];
HDdata40LuzPerMouse = [];
WTdata400LuzPerMouse = [];
HDdata400LuzPerMouse = [];

for i = 1:length(twdb)
    LightAversion = twdb(i).LightAversion;
    if isempty(LightAversion)
        continue
    end
   
    % WT 4 Luz
    if ismember(i, WTmice)
       % WTFilteredYng = [WTFilteredYng, i];
        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 4
                continue
            end
            
            TimeInLightWT4Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            
            WTdata4LuzPerMouse = [WTdata4LuzPerMouse, TimeInLightWT4Luz];   
        end
        
        WTdata4Luz{end+1} = WTdata4LuzPerMouse;
        WTdata4LuzPerMouse = [];
        
    end
    % HD 4 Luz
    if ismember(i, HDmice)

        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 4
                continue
            end
            TimeInLightHD4Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            HDdata4LuzPerMouse = [HDdata4LuzPerMouse, TimeInLightHD4Luz];
        end
        
        HDdata4Luz{end+1} = HDdata4LuzPerMouse;
        HDdata4LuzPerMouse = [];
        
    end
    % WT 40 Luz
    if ismember(i, WTmice)
        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 40
                continue
            end
            TimeInLightWT40Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            WTdata40LuzPerMouse = [WTdata40LuzPerMouse, TimeInLightWT40Luz];
        end
        WTdata40Luz{end+1} = WTdata40LuzPerMouse;
        WTdata40LuzPerMouse = [];
    end
    % HD 40 Luz
    if ismember(i, HDmice)
        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 40
                continue
            end
            TimeInLightHD40Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            HDdata40LuzPerMouse = [HDdata40LuzPerMouse, TimeInLightHD40Luz];
        end
        HDdata40Luz{end+1} = HDdata40LuzPerMouse;
        HDdata40LuzPerMouse = [];
    end
    % WT 400 Luz
    if ismember(i, WTmice)
        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 400
                continue
            end
            TimeInLightWT400Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            WTdata400LuzPerMouse = [WTdata400LuzPerMouse, TimeInLightWT400Luz];
        end
        
        %WTdataOld = {WTdataOld; WTdataOldPerMouse};
        WTdata400Luz{end+1} = WTdata400LuzPerMouse;
        WTdata400LuzPerMouse = [];
        
    end
    %HD 400 Luz
    if ismember(i, HDmice)
        for m = 1:height(LightAversion)
            if LightAversion.POINT(m) > 2
                continue
            end
            if LightAversion.LIGHT_LEVEL(m) ~= 400
                continue
            end
            TimeInLightHD400Luz = LightAversion.Light_Time(m)/(LightAversion.Dark_Time(m)...
                + LightAversion.Light_Time(m));
            HDdata400LuzPerMouse = [HDdata400LuzPerMouse, TimeInLightHD400Luz];
        end
       % HDdataOld = {HDdataOld; HDdataOldPerMouse};
        HDdata400Luz{end+1} = HDdata400LuzPerMouse;
        HDdata400LuzPerMouse = [];
    end
end

AvgArray(WTdata4Luz)
AvgArray(HDdata4Luz)
AvgArray(WTdata40Luz)
AvgArray(WTdata40Luz)
AvgArray(WTdata400Luz)
AvgArray(HDdata400Luz)

ydata = {AvgArray(WTdata4Luz), AvgArray(HDdata4Luz), AvgArray(WTdata40Luz), AvgArray(HDdata40Luz), AvgArray(WTdata400Luz), AvgArray(HDdata400Luz)};
title = 'Percent time spent in light up to Bin 2';
xlabel = {'4 Luz', '', '40Luz', '', '400Luz', ''};
ylabel = 'percent time spent in light';

% figure();
% hold on;
% plotBar(ydata, ylabel, xlabel, title)
% hold off;

