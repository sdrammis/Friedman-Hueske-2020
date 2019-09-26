function [hP, hL] = dg_plotShadeCL(hA, data, varargin)
%[hP, hL] = dg_shadeCL(hA, data)
% Sets "hold on" and plots a shaded confidence limit area, together with an
% optional solid line.  Sadly, Matlab gives up when asked to produce an EPS
% file containing transparent patches and produces an EPS containing
% bitmaps instead.  Therefore, the default behavior is to set FaceAlpha to
% 1 and set FaceColor to a mix of 25% Color and 75% white so that the
% figure can be saved as true EPS (i.e. in vector format).
%
%INPUTS
% hA: axes into which to plot.
% data: column 1 is X, column 2 is lower CL, column 3 is upper CL.  There
%   may optionally be a fourth column, which is a series of Y values to
%   plot as a solid line.
%
%OUTPUTS
% hP: handle to the patch object.
% hL: handle to line object if one was plotted; otherwise [].
%
%OPTIONS
%  All options except for the following are taken to be properties of the
%   optional solid line object.
% 'Color', color - sets the color of both the patch object and (if plotted)
%   the solid line object.
% 'FaceAlpha', alpha - sets the 'facealpha' property of the patch object
% 'FaceColor', facecolor - sets FaceColor to <facecolor> for the CL patch.
%   'facecolor' (no caps) will also work.
%
%NOTES
% Thanks and a tip of the hat to Andrew McCool.
 
%$Rev: 147 $
%$Date: 2012-02-17 15:29:24 -0500 (Fri, 17 Feb 2012) $
%$Author: dgibson $
 
hL = [];
args2delete = [];
facecolor = [];
plotcolor = [];
facealpha = 1;
argnum = 1;
while argnum <= length(varargin)
    switch varargin{argnum}
        case {'Color' 'color'}
            argnum = argnum + 1;
            plotcolor = varargin{argnum};
        case {'FaceAlpha' 'facealpha'}
            args2delete(end+1) = argnum; %#ok<*AGROW>
            argnum = argnum + 1;
            args2delete(end+1) = argnum;
            facealpha = varargin{argnum};
        case {'FaceColor' 'facecolor'}
            args2delete(end+1) = argnum; %#ok<*AGROW>
            argnum = argnum + 1;
            args2delete(end+1) = argnum;
            facecolor = varargin{argnum};
    end
    argnum = argnum + 1;
end
varargin(args2delete) = [];
if isempty(plotcolor)
    plotcolor = [0 0 1];
end
if isempty(facecolor)
    facecolor  = (plotcolor + 3 * [1 1 1]) / 4;
end
 
 
xdata = [data(:,1); data(end:-1:1,1)];
ydata = [data(:,2); data(end:-1:1,3)];
set(hA, 'NextPlot', 'add');
axes(hA); %#ok<MAXES>
hP = patch(xdata, ydata, facecolor, 'edgecolor', 'none', ...
    'facealpha', facealpha);
if size(data,2) > 3
    hL = plot(hA, data(:,1), data(:,4), varargin{:});
end
