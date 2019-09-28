import { Work } from "./types";

export default class Queue {
  queue: Work[] = [];

  find(work: Work): number | null {
    const { exid, workerName } = work;
    const idx = this.queue.findIndex((w, idx) => w.exid === exid && w.workerName === workerName);
    return idx >= 0 ? idx : null;
  }

  enqueue(work: Work) {
    this.queue.push(work);
  }

  dequeue(): Work | null {
    if (this.isEmpty()) {
      return null;
    }
    return this.queue.shift();
  }

  isEmpty() {
    return this.queue.length === 0;
  }
}
