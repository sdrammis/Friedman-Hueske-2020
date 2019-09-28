import * as fs from "mz/fs";
import { LowdbAsync } from "lowdb";
const mkdirpPromise = require("mkdirp-promise"); // no typings
import * as bluebird from "bluebird";
import * as cp from "child_process";
import extra, { Ext, Schema } from "striomatrix-cv-extra";

import config from "../config";
import db from "./db";

export default abstract class Worker {
  isRoot: boolean = false;
  name_: string;
  deps: string[];
  ext: Ext;
  scriptName: string;

  async setup() {
    await mkdirpPromise(`${config.FS_ROOT}/${this.name_}/tmp/`);
    await mkdirpPromise(`${config.FS_ROOT}/${this.name_}/manual/`);
    await mkdirpPromise(`${config.FS_ROOT}/${this.name_}/done/`);
    if (this.isRoot) {
      await mkdirpPromise(`${config.FS_ROOT}/pre_${this.name_}/tmp/`);
      await mkdirpPromise(`${config.FS_ROOT}/pre_${this.name_}/manual/`);
      await mkdirpPromise(`${config.FS_ROOT}/pre_${this.name_}/done/`);
      this.deps = [`pre_${this.name_}`];
    }
  }

  abstract async run(exid: string): Promise<void>;

  async writeManualDone(exid: string): Promise<void> {
    await this.writeDone("manual", exid);
  }

  async writeDoneDone(exid: string): Promise<void> {
    await this.writeDone("done", exid);
  }

  private async writeDone(folder: string, exid: string) {
    await fs.writeFile(
      `${config.FS_ROOT}/${this.name_}/${folder}/${exid}-done.txt`,
      ""
    );
  }

  protected async runScript(
    exid: string,
    inputs: string[],
    scriptName_?: string
  ) {
    const scriptName = scriptName_ ? scriptName_ : this.scriptName;
    const { MATLAB_PATH, WORKERS_PATH } = config;
    const dir = `${config.FS_ROOT}/${this.name_}`;

    const { experiment, slice } = await db.findEx(exid);
    const imageName = extra.utils.getImage(slice, this.ext).toLowerCase();
    const image = `${config.IMAGES_FOLDER}/${experiment}/${imageName}`;

    const area = extra.utils.getImageArea(
      `${config.FS_ROOT}/dimensions.xlsx`,
      slice
    );
    if (area === undefined) {
      throw new Error(`${this.name_}: image area is undefined`);
    }

    let inputStr = `'${exid}', '${image}', ${area}, '${dir}/tmp', '${dir}/manual', '${dir}/done'`;
    let inputs_ = inputs.reduce((s, x) => `${s}'${x}', `, "");
    inputs_ = inputs_.slice(0, inputs_.length - 2);
    if (inputs_.length > 0) {
      inputStr += `, ${inputs_}`;
    }

    const cmd = `${MATLAB_PATH} -nosplash -nodesktop -r "addpath(genpath('${WORKERS_PATH}')); call_worker('${scriptName}', ${inputStr})"`;
    console.log(cmd);

    await new Promise((res, rej) => {
      const child = cp.exec(cmd, (err, _, stderr) => {
        const e =
          err || stderr
            ? new Error(`${this.name_}: ${stderr.toString()}`)
            : null;
        if (e) rej(e);
        res();
      });
      process.on("exit", () => {
        child.kill;
      });
    });
  }

  async getNewWork(): Promise<string[]> {
    const depsExIDs = await Promise.all(
      this.deps.map(async dep => {
        const files = await fs.readdir(`${config.FS_ROOT}/${dep}/done`);
        const exids = files
          .filter(f => f.includes("-done.txt"))
          .map(f => f.split("-done.txt")[0]);
        return exids;
      })
    );

    // NOTE: This is not the most efficient, but the most concise
    const readyExIDs = []
      .concat(...depsExIDs)
      .filter(
        (id, _, arr) =>
          arr.filter(idArr => idArr === id).length === this.deps.length
      )
      .filter((id, idx, arr) => arr.indexOf(id) === idx);

    // NOTE: Maybe this should all be tracked in a database file?
    const dir = `${config.FS_ROOT}/${this.name_}`;
    const newExIDs = await bluebird.filter(readyExIDs, async exid => {
      const inManual = await fs.exists(`${dir}/manual/${exid}-done.txt`);
      const inDone = await fs.exists(`${dir}/done/${exid}-done.txt`);
      return !(inManual || inDone);
    });

    return newExIDs;
  }
}
