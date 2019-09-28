import os
d = "\\\\chunky.mit.edu\\analysis3\\strio_matrix_cv\\Alexander_Emily_Erik\\FINAL EXPORTED IMAGES\\experiment 9\\" 

for ext in ['fitc', 'cy5', 'dapi']:	
    if ext == 'fitc':
        new = 'MSN'
    elif ext == 'cy5':
        new = 'PV'
    elif ext == 'dapi':
        new = 'HDprot'
    for filename in os.listdir(d):
        newname = filename.replace(ext, new)
        os.rename(d + filename, d + newname)
        print(newname)
