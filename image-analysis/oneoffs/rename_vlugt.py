import os

d = "\\\\chunky.mit.edu\\smbshare\\annex4\\afried\\resultfiles\\FINAL_EXPORTED_IMAGES\\VGLUTV2_slide7"
for f in os.listdir(d):
    if f.startswith('.'):
        continue

    print(f)
    fNew = f.replace('DAPI', 'allcells').replace('qFIT', 'msn').replace('qCy5', 'strio').replace('qTex', 'vglut')
    fNew = fNew.lower()
    print(fNew)
    print("-----------------------------")
    os.rename(d + "\\" + f, d + "\\" + fNew)
