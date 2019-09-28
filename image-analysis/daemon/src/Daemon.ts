import Queue from "./Queue";
import Set from "./Set";
import { Work } from "./types";
import Worker from "./Worker";
import logger from "./logger";
import config from "../config";

const keygen = (w: Work) => `${w.exid}#${w.workerName}`;

export default class Daemon {
  max = 4;
  queue: Queue;
  workers: Worker[];
  running = new Set<Work>(keygen);
  completed = new Set<Work>(keygen);
  failed = new Set<Work>(keygen);

  constructor(public workersMap: { [key: string]: Worker }) {
    this.workers = Object.values(this.workersMap);
    this.queue = new Queue();
    logger.info(`Created with folder root ${config.FS_ROOT}`, "Daemon");
  }

  async addRunning(work: Work) {
    this.running.add(work);
  }

  isNew(work: Work) {
    return this.queue.find(work) === null && !this.running.has(work);
  }

  runWork(work: Work[]) {
    work.forEach(w => {
      this.addRunning(w);
      this.runWorkerWork(w);
    });
  }

  async runWorkerWork(work: Work) {
    logger.info(`Starting work ${work.exid} ${work.workerName}`, "Daemon");
    try {
      await this.workersMap[work.workerName].run(work.exid);
      this.completed.add(work);
      this.running.delete(work);
      logger.info(`Finished work ${work.exid} ${work.workerName}`, "Daemon");
    } catch (e) {
      logger.error(e, "Daemon");
      this.failed.add(work);
      this.running.delete(work);
    }
  }

  async getNewWork(): Promise<Work[]> {
    const workersWork = await Promise.all(
      this.workers.map(async worker => {
        try {
          return this.getWorkerNewWork(worker);
        } catch (e) {
          logger.error(e, "Deamon");
          return [];
        }
      })
    );
    return [].concat(...workersWork).filter(w => !this.failed.has(w));
  }

  async getWorkerNewWork(worker: Worker): Promise<Work[]> {
    return (await worker.getNewWork())
      .filter(exid => this.isNew({ exid, workerName: worker.name_ }))
      .map(exid => ({ workerName: worker.name_, exid }));
  }

  run = async () => {
    const { queue, running, max } = this;
    if (running.size() >= max) {
      logger.info(`Running size = ${running.size()}`, "Daemon");
      setTimeout(this.run, 3 * 60 * 1000);
      return;
    }

    const newWork = await this.getNewWork();
    newWork.map(w => queue.enqueue(w));
    const emptySlots = max - running.size();
    const workToRun = [...Array(emptySlots)]
      .map(_ => queue.dequeue())
      .filter(x => !!x);
    this.runWork(workToRun);
    logger.info(`Running size = ${running.size()}`, "Daemon");
    setTimeout(this.run, 1 * 60 * 1000);
  };
}
