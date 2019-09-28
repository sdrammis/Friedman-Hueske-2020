import os

d = "\\\\chunky.mit.edu\\annex4\\afried\\resultfiles\\slides_5_6"
for f in os.listdir(d):
    if f.startswith('.') or f.startswith('@'):
        continue

    fNew = f.replace('Cy5', 'pv').replace('Dapi', 'hd').replace('Fitc', 'msn').lower()
    print(fNew)
    print("-----------------------------")
    os.rename(d + "\\" + f, d + "\\" + fNew)
