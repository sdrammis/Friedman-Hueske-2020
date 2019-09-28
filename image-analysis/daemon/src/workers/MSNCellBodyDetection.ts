import extra, { Ext } from "striomatrix-cv-extra";
import * as bluebird from "bluebird";

import Worker from "../Worker";
import logger from "../logger";
import config from "../../config";
import * as fs from "mz/fs";

export const name = "msn_cell_body_detection";

export default class MSNCellBodyDetection extends Worker {
  name_ = name;
  deps: string[] = [];
  isRoot = true;
  scriptName = "MSNCellBodyDetection_run";
  ext = Ext.MSN;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    await this.runScript(exid, []);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
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

    // TODO remove this -- hack to run only young animals
    return newExIDs.filter(exid => exid.includes('yng'));
  }
}
