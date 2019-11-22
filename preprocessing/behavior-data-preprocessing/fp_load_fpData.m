function [var]=fp_load_fpData(blue_imageStackValues,blue_imageStackTimestamps,purple_imageStackValues,purple_imageStackTimestamps,iFiber)

var.bV=blue_imageStackValues(:,iFiber);
var.bT=blue_imageStackTimestamps;
var.pV=purple_imageStackValues(:,iFiber);
var.pT=purple_imageStackTimestamps;