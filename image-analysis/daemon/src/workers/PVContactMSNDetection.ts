import extra, { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import logger from "../logger";
import config from "../../config";

export const name = "pv_contact_msn_detection";

export default class PVContactMSNDetection extends Worker {
  name_ = name;
  deps: string[] = [];
  isRoot = true;
  scriptName = "PVContactMSNDetection_run";
  ext = Ext.PV;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    await this.runScript(exid, []);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
