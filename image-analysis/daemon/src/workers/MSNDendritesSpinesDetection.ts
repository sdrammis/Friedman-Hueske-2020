import { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import logger from "../logger";
import { name as MSNCellBodyDetectionName } from "./MSNCellBodyDetection";
import config from "../../config";

export const name = "msn_dendrites_spines_detection";

export default class MSNDendritesSpinesDetection extends Worker {
  name_ = name;
  deps: string[] = [MSNCellBodyDetectionName];
  isRoot = false;
  scriptName = "MSNDendritesSpinesDetection_run";
  ext = Ext.MSN;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);
    const { FS_ROOT } = config;
    const inputData = `${FS_ROOT}/${MSNCellBodyDetectionName}/done/${exid}-data.mat`;

    await this.runScript(exid, [inputData]);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
