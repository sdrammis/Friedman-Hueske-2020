import extra, { Ext } from "striomatrix-cv-extra";
import Worker from "../Worker";
import logger from "../logger";
import config from "../../config";
import { name as PVCellBodyDetectionName } from "./PVCellBodyDetection";

export const name = "pv_dendrite_detection";

const STAIN2_EXPS = ["exp7", "exp8", "exp9"];

export default class PVDendriteDetection extends Worker {
  name_ = name;
  deps: string[] = [PVCellBodyDetectionName];
  isRoot = false;
  scriptName = "PVDendriteDetection_run";
  ext = Ext.PV;

  async run(exid: string) {
    logger.info(`Doing work with exid: "${exid}"`, name);

    const { FS_ROOT } = config;
    const inputData = `${FS_ROOT}/${PVCellBodyDetectionName}/done/${exid}-data.mat`;

    const isStain2 =
      STAIN2_EXPS.map(s => exid.indexOf(s)).filter(x => x >= 0).length > 0;
    const suffx = isStain2 ? "_stain2" : "_stain1";
    const scriptName = this.scriptName + suffx;

    await this.runScript(exid, [inputData], scriptName);
    await this.writeManualDone(exid);
    logger.info(`Done with work with exid: "${exid}"`, name);
  }
}
