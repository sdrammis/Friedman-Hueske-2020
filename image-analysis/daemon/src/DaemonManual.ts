import * as cp from "mz/child_process";
import * as fs from "mz/fs";
import extra from "striomatrix-cv-extra";

import ch from "./messaging";
import config from "../config";
import logger from "./logger";

interface ManualDoneMsg {
  name: string;
  exid: string;
  script: string;
  inputs: any[]; // TODO type this
}

export default class Daemon {
  async run() {
    extra.messaging.receive(await ch, "manual.done", this.handleMsg);
  }

  handleMsg = async (msg: ManualDoneMsg) => {
    const { name, exid, script, inputs } = msg;
    logger.info(
      `Running manual script for worker: ${name}, exid: ${exid}`,
      "DaemonManual"
    );

    await this.runMatlab(name, exid, script, inputs);
    await fs.writeFile(`${config.FS_ROOT}/${name}/done/${exid}-done.txt`, "");
  };

  async runMatlab(name: string, exid: string, script: string, inputs: any[]) {
    const { MATLAB_PATH, WORKERS_PATH } = config;
    const dir = config.FS_ROOT + "/" + name;
    const outDir = `${dir}/done`;
    const tmpDir = `${dir}/tmp`;
    const manualDir = `${dir}/manual`;

    let inputs_ = inputs.reduce((s, x) => `${s}'${JSON.stringify(x)}', `, "");
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
}
