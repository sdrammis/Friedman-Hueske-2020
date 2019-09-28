import { Ext } from "striomatrix-cv-extra";

import Worker from "../Worker";
import { name as PVCellBodyDetectionName } from "./PVCellBodyDetection";
import logger from "../logger";
import config from "../../config";

export const name = "pv_expression";

export default class PVExpression extends Worker {
  name_ = name;
  deps: string[] = [PVCellBodyDetectionName];
  isRoot = false;
  scriptName = "PVExpression_run";
  ext = Ext.PV;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    const { FS_ROOT } = config;
    const inputData = `${FS_ROOT}/${PVCellBodyDetectionName}/done/${exid}-data.mat`;

    await this.runScript(exid, [inputData]);
    await this.writeDoneDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
