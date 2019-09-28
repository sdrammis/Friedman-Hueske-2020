import * as fs from "mz/fs";
import * as cp from "mz/child_process";
import * as bluebird from "bluebird";

import config from "../../../config";

export const rerun = async (dir: string, exid: string, cb: () => void) => {
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

export const reselect = async (dir: string, exid: string) => {
  return new Promise(async (res, rej) => {
    try {
      await fs.unlink(`${dir}/done/${exid}-done.txt`);
      res();
    } catch (e) {
      rej(e);
    }
  });
};

export async function getManualWork(name: string) {
  const filesManual = await fs.readdir(`${config.FS_ROOT}/${name}/manual`);
  const exidsManual = filesManual
    .filter(f => f.includes("-done.txt"))
    .map(f => f.split("-done.txt")[0]);

  const filesDone = await fs.readdir(`${config.FS_ROOT}/${name}/done`);
  const exidsDone = filesDone
    .filter(f => f.includes("-done.txt"))
    .map(f => f.split("-done.txt")[0]);

  const exids = await bluebird.filter(exidsManual, async exid => {
    return !exidsDone.includes(exid);
  });
  return exids;
}

export async function runMatlab(
  name: string,
  exid: string,
  script: string,
  inputs: string[]
) {
  const { MATLAB_PATH, WORKERS_PATH } = config;
  const dir = getDir(name);
  const outDir = `${dir}/done`;
  const tmpDir = `${dir}/tmp`;
  const manualDir = `${dir}/manual`;

  let inputs_ = inputs.reduce((s, x) => `${s}'${x}', `, "");
  inputs_ = inputs_.slice(0, inputs_.length - 2);
  inputs_ = `'${exid}', '${outDir}', '${tmpDir}', '${manualDir}', ${inputs_}`;
  const cmd = `${MATLAB_PATH} -nosplash -nodesktop -r "addpath(genpath('${WORKERS_PATH}')); call_worker('${script}', ${inputs_})"`;
  console.log(cmd);

  await new Promise((res, rej) => {
    const child = cp.exec(cmd, (err, _, stderr) => {
      const e =
        err || stderr ? new Error(`${name}: ${stderr.toString()}`) : null;
      if (e) rej(e);
      res();
    });
    process.on("exit", () => {
      child.kill;
    });
  });
}

export function getDir(name: string) {
  return config.FS_ROOT + "/" + name;
}

export async function writeDone(name: string, exid: string) {
  await fs.writeFile(`${getDir(name)}/done/${exid}-done.txt`, "");
}
