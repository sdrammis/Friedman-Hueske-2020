import * as fs from "mz/fs";
import extra from "striomatrix-cv-extra";
import db from "../db";

const PRE_FOLDER_PATH =
  "/Volumes/smbshare/analysis3/strio_matrix_cv/system-tree/pre_msn_cell_body_detection/done";
const IMAGES_PATH =
  "/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES";

async function findImage(exp: string, mouse: string, section: string) {
  const r = /(_(msn|pv|hdprot|strio|vglut))?(_(-?[0-9]{0,10}))?.tiff/;
  const expFolder = `${IMAGES_PATH}/experiment ${exp}/`;

  const files = (await fs.readdir(expFolder)).filter(f => !f.startsWith("._"));
  const slices = [...new Set(files.map(f => f.replace(r, "")))];
  const image = slices.filter(
    slice => slice.indexOf(mouse) > -1 && slice.indexOf(section) > -1
  );

  if (image.length != 1) {
    const err = `Could not find image for exp=${exp}, mouse=${mouse}, section=${section}`;
    throw new Error(err);
  }
  return image[0];
}

async function getExpAndSlice(exid: string) {
  const split = exid.split("_");
  const exp = split[0].replace("exp", "");

  const image = await findImage(exp, split[1], split[2]);
  return { exp: `experiment ${exp}`, slice: image };
}

async function run() {
  const dirconts = await fs.readdir(PRE_FOLDER_PATH);
  for (let item of dirconts) {
    if (!item.includes("exp")) {
      continue;
    }

    const exid = item.replace("-done.txt", "");
    console.log(`Trying exid=${exid}...`);
    const ex = await db.findEx(exid);
    if (ex != undefined) {
      console.log(`exid=${exid} alread in db`);
      continue;
    }

    try {
      const { exp, slice } = await getExpAndSlice(exid);
      console.log(`Inserting exid=${exid}...`);
      await db.newEx(exid, exp, slice);
    } catch (e) {
      console.log(`Failed to insert exid=${exid}...`);
      await fs.appendFile(
        "./err-log.txt",
        `Failed on ${exid} with error - ${e} \n`
      );
    }
  }
}

run();
