import extra, { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import logger from "../logger";

export const name = "pv_cell_body_detection";

const STAIN2_EXPS = ["exp7", "exp8", "exp9"];

export default class PVCellBodyDetection extends Worker {
  name_ = name;
  deps: string[] = [];
  isRoot = true;
  scriptName = "PVCellBodyDetection_run";
  ext = Ext.PV;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    const isStain2 =
      STAIN2_EXPS.map(s => exid.indexOf(s)).filter(x => x >= 0).length > 0;
    const suffx = isStain2 ? "_stain2" : "_stain1";
    const scriptName = this.scriptName + suffx;

    await this.runScript(exid, [], scriptName);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
