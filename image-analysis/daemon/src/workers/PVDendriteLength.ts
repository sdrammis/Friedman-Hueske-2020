import extra, { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import logger from "../logger";

export const name = "pv_dendrite_length";

export default class PVDendriteLength extends Worker {
  name_ = name;
  deps: string[] = [];
  isRoot = true;
  scriptName = "PVDendriteLength_run";
  ext = Ext.PV; // TODO

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    await this.runScript(exid, []); // TODO : inputs
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
