import * as fs from "mz/fs";

import { ValMap, MaskMap, Metadata } from "../types";
import logger from "../../../../logger";
import { writeDone } from "../../utils";

export async function submit(
  dir: string,
  name: string,
  exid: string,
  map: ValMap,
  masksMap: MaskMap,
  metadata: Metadata
) {
  const data = {
    regionThreshMap: [...map],
    regionMaskMap: [...masksMap],
    regionData: metadata
  };

  const numThresholds = metadata.dendThreshs.length;
  await fs.writeFile(`${dir}/done/${exid}-threshs.json`, JSON.stringify(data));
  for (let t = 1; t <= numThresholds; t++) {
    await fs.copyFile(
      `${dir}/manual/${exid}-${t}-data.mat`,
      `${dir}/done/${exid}-${t}-data.mat`,
      e => {
        if (e) logger.error(e.message, this.name);
      }
    );
  }
  await writeDone(name, exid);
}

export async function getNextEx(dir: string, exid: string, todo: string[]) {
  const exidIdx = todo.indexOf(exid);
  const todoNew = todo
    .slice(0, exidIdx)
    .concat(todo.slice(exidIdx + 1, todo.length));
  const buff = await fs.readFile(`${dir}/manual/${exid}-data.json`);
  const metadataNew = JSON.parse(buff.toString());
  return { todoNew, metadataNew };
}
