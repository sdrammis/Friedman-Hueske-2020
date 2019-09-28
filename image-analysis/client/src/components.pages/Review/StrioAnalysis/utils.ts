import * as fs from "mz/fs";

export const rerunIdent = async (dir: string, exid: string, cb: () => void) => {
  try {
    await fs.unlink(`${dir}/manual/${exid}-done.txt`);
  } catch (e) {
    console.warn(
      `Could not find file strio analysis manual file: ${e.toString}`
    );
  }

  try {
    await fs.unlink(`${dir}/done/${exid}-done.txt`);
  } catch (e) {
    console.warn(`Could not find file strio analysis done file: ${e.toString}`);
  }
  cb();
};

export const rerunDraw = async (
  dir: string,
  preDir: string,
  exid: string,
  cb: () => void
) => {
  try {
    await fs.unlink(`${preDir}/done/${exid}-done.txt`);
  } catch (e) {
    console.warn(
      `Could not find file PRE strio analysis done file: ${e.toString}`
    );
  }
  rerunIdent(dir, exid, cb);
};
