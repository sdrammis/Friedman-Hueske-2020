import os

d = "/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES/young_animals_exports"
for f in os.listdir(d):
    if f.startswith('.'):
        continue

    print f
    fNew = f.replace('Cy5', 'pv').replace('Dapi', 'vglut').replace('Fitc', 'msn').replace('Texa', 'strio')
    print fNew
    print "-----------------------------"
    os.rename(d + "/" + f, d + "/" + fNew)
