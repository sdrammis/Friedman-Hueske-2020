import * as fs from "mz/fs";

import config from "../config";
import Daemon from "./Daemon";
import StrioAnalysisWorker, {
  name as StrioAnalysisWorkerName
} from "./workers/StrioAnalysis";
import MSNCellBodyDetection, {
  name as MSNCellBodyDetectionName
} from "./workers/MSNCellBodyDetection";
import MSNDendritesSpinesDetection, {
  name as MSNDendritesSpinesDetectionName
} from "./workers/MSNDendritesSpinesDetection";
import PVCellBodyDetection, {
  name as PVCellBodyDetectionName
} from "./workers/PVCellBodyDetection";
import PVDendriteDetection, {
  name as PVDendriteDetectionName
} from "./workers/PVDendriteDetection";
import PVExpression, { name as PVExpressionName } from "./workers/PVExpression";

const WORKERS = {
  // [MSNCellBodyDetectionName]: new MSNCellBodyDetection(),
  [MSNDendritesSpinesDetectionName]: new MSNDendritesSpinesDetection()
  //[PVCellBodyDetectionName]: new PVCellBodyDetection(),
  //[PVDendriteDetectionName]: new PVDendriteDetection()
  //[StrioAnalysisWorkerName]: new StrioAnalysisWorker(),
  //[PVExpressionName]: new PVExpression()
};

var cleanExit = function() {
  process.exit();
};
process.on("SIGINT", cleanExit); // catch ctrl-c
process.on("SIGTERM", cleanExit); // catch kill

(async () => {
  await fs.copyFile(
    `${config.FS_ROOT}/db.json`,
    `${config.FS_ROOT}/db-snapshots/db-${Date.now()}.json`,
    e => (e ? console.error(e) : null)
  );
  await Promise.all(Object.values(WORKERS).map(w => w.setup()));
  const d = new Daemon(WORKERS);
  d.run();
})();
