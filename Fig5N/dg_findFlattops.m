function [vmaxidx, runidx, endrunidx] = dg_findFlattops(samples, varargin)
%vmaxidx = dg_findFlattops(samples, thresh1, thresh2)
% This is a variation on dg_findPeaks which is tolerant of flat tops on the
% peaks.  The definition of a peak is thus extended to include any series
% of samples in which the first is strictly less than the second and the
% last is strictly less than the second to last, and all internal samples
% are equal.
%INPUTS
% samples: a vector of time series values.
% thresh1: optional argument.  If given, then the value of the internal
%   samples must be strictly greater than <thresh1>.
% thresh2: optional argument.  If given, then the internal samples must be
%   strictly less than <thresh2>.
%OUTPUTS
% vmaxidx: index into <samples> of the first sample of each (potentially
%   flat-topped) peak.  Flat-topped peaks are indicated by
%   ismember(vmaxidx, runidx).
% runidx: index into <samples> of the first index in each flat run, not
%   including runs that start at the first sample or end on the last
%   sample.
% endrunidx:  index into <samples> of the last index in each flat run, not
%   including runs that start at the first sample or end on the last
%   sample.
%NOTES
% The strategy here is to find all consecutive runs of equal-valued samples
% in <samples> that are greater than <thresh1> and condense them down to a
% single sample.  The resulting de-flat-topped time series is then
% submitted to dg_findPeaks, and the results are converted back to the
% original index space.

%$Rev: 127 $
%$Date: 2011-08-12 16:54:36 -0400 (Fri, 12 Aug 2011) $
%$Author: dgibson $

if length(varargin) == 0
    varargin = {-Inf};
end
thresh1 = varargin{1};

% <isflatrun> is true for each sample > thresh1 that is followed by the
% identical value.  This means that the last sample of the run is
% represented by the first <false> value after a <true>.  The last sample
% is always <false> because it is not followed by the identical value.
isflatrun = [ 
    reshape(diff(samples) == 0 & samples(2:end) > thresh1, [], 1)
    false
    ];
% We arbitrarily define that the first run cannot start on the first
% sample, because if the first several samples are equal, they could not be
% part of a peak anyway.
runidx = find([
    false
    reshape(isflatrun(2:end) & ~isflatrun(1:end-1), [], 1)
    ]);
% <endrunidx> is the last sample of each multi-sample run.
% It is logically impossible for the first sample to be the end of the
% first run, because then it would a single sample and not a run.
endrunidx = find([
    false
    reshape(~isflatrun(2:end) & isflatrun(1:end-1), [], 1)
    ]);
if ~isempty(endrunidx)
    if isempty(runidx)
        % If one is empty, then the other one should be too
        endrunidx = [];
    elseif endrunidx(1) < runidx(1)
        % endrunidx(1) is the end of a series of equal samples starting at
        % sample 1, which is by definition not a run:
        endrunidx(1) = [];
    end
end
if ~isempty(endrunidx) && endrunidx(end) == length(samples)
    % Symmetrically to the considerations for the first run, the last run
    % is not allowed to end on the last sample:
    endrunidx(end) = [];
    if ~isempty(runidx)
        runidx(end) = [];
    end
end
if length(runidx) ~= length(endrunidx)
    error('dg_findFlattops:oops', ...
        'Run length discrepancy: %d vs. %d', ...
        length(runidx), length(endrunidx));
end
clear isflatrun;

% We now have a list of the starting and ending samples of each accepted
% flat run in <runidx> and <endrunidx>.  We use this to create a logical
% index into <samples> s.t. <samples(sampidx)> has all accepted flat runs
% shortened to a single samples.  While we're at it, we also compute the
% offset that must be applied to indices into the shortened <samples> to
% convert to indices into the original <samples>.  The kth offset is the
% one that applies after the kth run.  And we also need to know when to
% apply the kth offset, i.e. when the index into shortened <samples> is
% greater than threshidx(k).
isuniquesample = false(size(samples));
offset = zeros(size(runidx));
threshidx = zeros(size(runidx));
sampidx = 1;
for runnum = 1:length(runidx)
    nonrunidx = sampidx:runidx(runnum);
    isuniquesample(nonrunidx) = true;
    sampidx = endrunidx(runnum) + 1;
    if runnum == 1
        offset(1) = endrunidx(runnum) - runidx(runnum);
        threshidx(1) = length(nonrunidx);
    else
        offset(runnum) = endrunidx(runnum) - runidx(runnum) ...
            + offset(runnum - 1);
        threshidx(runnum) = length(nonrunidx) + threshidx(runnum - 1);
    end
end
nonrunidx = sampidx:length(samples);
isuniquesample(nonrunidx) = true;
    
vmx = dg_findPeaks(samples(isuniquesample), varargin{:});
vmaxidx = vmx;
for runnum = 1 : (length(runidx) - 1)
    useoffset = ...
        vmx > threshidx(runnum) & vmx <= threshidx(runnum+1);
    vmaxidx(useoffset) = vmx(useoffset) + offset(runnum);
end
if ~isempty(threshidx)
    useoffset = vmx > threshidx(end);
    vmaxidx(useoffset) = vmx(useoffset) + offset(end);
end
