function vmaxidx = dg_findPeaks(samples, thresh1, thresh2)
%vmaxidx = dg_findPeaks(samples, thresh1, thresh2)
%   <thresh2> is optional. Returns a column vector of indices into
%   <samples> of 3-point maxima that are greater than <thresh1> and
%   (if given) less than <thresh2>.  The middle point must be strictly
%   greater than either of its neighbors to qualify as a 3-point maximum.
%NOTES
%   Same as lfp_findPeaks, except that <samples> is a vector of literal
%   samples data instead of a CSC channel number.

%$Rev: 137 $
%$Date: 2011-12-20 19:49:40 -0500 (Tue, 20 Dec 2011) $
%$Author: dgibson $

allocsize = 2^14;

% Start by qualifying small regions of the trace to search for maxima:
qualifiedpts(:,1) = reshape(samples(:) > thresh1, [], 1);
% Since the first and last point of each 3-point maximum do not have to
% meet the minimum threshold criterion, we must expand the qualified
% regions by one point on each side:
qualifiedpts = qualifiedpts | [0; qualifiedpts(1:end-1)] ...
    | [ qualifiedpts(2:end); 0] ;
if nargin > 2
    qualifiedpts = qualifiedpts & ...
        reshape(samples(:) < thresh2, [], 1);
end
qualstarts = [ qualifiedpts(1)
    qualifiedpts(2:end) & ~qualifiedpts(1:end-1) ];
qualends = [ qualifiedpts(1:end-1) & ~qualifiedpts(2:end)
    qualifiedpts(end) ];
startidx = find(qualstarts);  % index into samples
endidx = find(qualends);  % index into samples
if length(startidx) ~= length(endidx)
    error('dg_findPeaks:badqual', ...
        'Internal error - call the geek squad!');
end

% Now search for 3-point maximum values:
vmaxidx = zeros(allocsize,1);
vmaxidxptr = 0;
for k = 1:length(startidx)
    ix1 = startidx(k);
    ix2 = endidx(k);
    localmaxidx = find([ false
        reshape(samples(ix1+1:ix2-1),[],1) ...
        > reshape(samples(ix1:ix2-2),[],1) ...
        & reshape(samples(ix1+1:ix2-1),[],1) ...
        > reshape(samples(ix1+2:ix2),[],1)
        false ]);
    if vmaxidxptr + length(localmaxidx) > size(vmaxidx,1)
        vmaxidx = [ vmaxidx; zeros(allocsize,1) ]; %#ok<AGROW>
    end
    vmaxidx(vmaxidxptr + (1:length(localmaxidx))) = ...
        localmaxidx + ix1 - 1;   % sample index
    vmaxidxptr = vmaxidxptr + length(localmaxidx);
end
vmaxidx(vmaxidxptr + 1 : end, :) = [];
