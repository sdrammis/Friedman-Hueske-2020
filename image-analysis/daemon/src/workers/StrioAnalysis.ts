import { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import logger from "../logger";
import config from "../../config";

export const name = "strio_analysis";

export default class StrioAnalysis extends Worker {
  name_ = name;
  deps: string[] = [];
  isRoot = true;
  scriptName = "StrioAnalysis_run";
  ext = Ext.Strio;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);
    const parentDir = `${config.FS_ROOT}/pre_strio_analysis/done`;
    const inputs = [`${parentDir}/${exid}-data.mat`];

    await this.runScript(exid, inputs);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
