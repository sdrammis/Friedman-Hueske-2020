import os
d = "\\\\chunky.mit.edu\\analysis3\\strio_matrix_cv\\Alexander_Emily_Erik\\FINAL EXPORTED IMAGES\\experiment 5\\" 

for ext in ['fitc', 'cy5', 'dapi', 'texa']:	
    if ext == 'fitc':
        new = 'MSN'
    elif ext == 'cy5':
        new = 'strio'
    elif ext == 'dapi':
        new = 'vglut'
    elif ext == 'texa':
        new = 'PV'
    for filename in os.listdir(d):
        newname = filename.lower().replace(ext, new)
        os.rename(d + filename, d + newname)
        print(d + newname)
