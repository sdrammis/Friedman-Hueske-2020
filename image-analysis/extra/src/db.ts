import * as fs from "mz/fs";

export interface Execution {
  exid: string;
  experiment: string;
  slice: string;
  createdAt: Date;
}

export interface Schema {
  executions: Execution[];
}

async function open(path: string): Promise<Schema> {
  if (!(await fs.exists(path))) {
    throw new Error("Database file not found!");
  }
  return JSON.parse((await fs.readFile(path)).toString());
}

export default class db {
  constructor(private dbPath: string) {}

  async newEx(exid: string, experiment: string, slice: string) {
    const data = await open(this.dbPath);
    const createdAt = new Date();
    data.executions.push({ exid, experiment, slice, createdAt });
    await fs.writeFile(this.dbPath, JSON.stringify(data));
  }

  async find(experiment: string, slice: string) {
    const data = await open(this.dbPath);
    const exs = data.executions.filter(
      d =>
        d.experiment.toLowerCase() === experiment.toLowerCase() &&
        d.slice.toLowerCase() === slice.toLowerCase()
    );
    return exs || ([] as Execution[]);
  }

  async findEx(exid: string) {
    const data = await open(this.dbPath);
    return data.executions.find(d => d.exid === exid);
  }

  async listExs(): Promise<Execution[]> {
    const data = await open(this.dbPath);
    return data.executions;
  }
}
