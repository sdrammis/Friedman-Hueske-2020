import os
d = "/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES/cell_counts_5"
for f in os.listdir(d):
    if f.startswith('.'):
        continue
    print f
    fNew = f.replace('cy5', 'strio')
    print fNew
    print "-----------------------------"
    os.rename(d + "/" + f, d + "/" + fNew.lower())
