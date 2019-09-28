import os
mapping = {"region 038": "2734_slice1", "region 039": "2734_slice2", "region 040":"2734_slice3", "region 041": "4947_slice1", "region 042": "4947_slice2", "region 043": "4947_slice3", "region 044": "2826_slice1", "region 045": "2826_slice2", "region 046": "2826_slice3", "region 047": "2824_slice1", "region 048": "2824_slice2", "region 050": "2824_slice3", "region 051": "2830_slice1", "region 052": "2830_slice2"}
d = "\\\\chunky.mit.edu\\analysis3\\strio_matrix_cv\\Alexander_Emily_Erik\\FINAL EXPORTED IMAGES\\experiment 9\\" 

for reg in mapping:
	for filename in os.listdir(d):
		print ("filename: ", filename)
		newname = filename.replace(reg, mapping[reg])
		print ("newname: ", newname)
		os.rename(d + filename, d + newname)
