var xlsx = require("node-xlsx").default;

export enum Ext {
  PV,
  MSN,
  Strio,
  VGlut,
  HDProt
}

export function getImage(exp: string, ext_: Ext) {
  let ext;
  switch (ext_) {
    case Ext.PV:
      ext = "pv.tiff";
      break;
    case Ext.MSN:
      ext = "msn.tiff";
      break;
    case Ext.Strio:
      ext = "strio.tiff";
      break;
    case Ext.VGlut:
      ext = "vglut.tiff";
      break;
    case Ext.HDProt:
      ext = "hdprot.tiff";
      break;
  }
  return `${exp}_${ext}`;
}

export function getImageArea(xlsxPath: string, exp: string) {
  const workSheetsFromFile = xlsx.parse(xlsxPath);
  const cols = workSheetsFromFile[0].data;
  for (const [imgPrefix, width, height] of cols) {
    if (
      imgPrefix &&
      imgPrefix.toLowerCase().replace(/\s/g, "") ===
        exp.toLowerCase().replace(/\s/g, "")
    ) {
      return width * height;
    }
  }
}
