import * as React from "react";
import extra, { Ext } from "striomatrix-cv-extra";
import { Button } from "semantic-ui-react";

import Selector from "../../components.common/Selector";
import db from "../../db";
import { getManualWork, runMatlab, getDir, writeDone } from "./utils";
import logger from "../../logger";
import config from "../../../config";

export const name = "pre_strio_analysis";

enum Status {
  LOADING,
  RUNNING,
  READY,
  CONFIRM
}

interface CompState {
  todo: string[];
  status: Status;
  exid: string | null;
  seed: number;
  err: string | null;
}

export default class PreStrioAnalysis extends React.Component<{}, CompState> {
  name = name;

  constructor(props: {}) {
    super(props);

    this.state = {
      todo: [],
      status: Status.LOADING,
      exid: null,
      seed: Date.now(),
      err: null
    };
  }

  componentWillMount() {
    this.load();
  }

  async load() {
    const todo = (await getManualWork(this.name)).filter(
      // Filter out experiments 7, 8, and 9 as there are no strio stains.
      s => !new RegExp(["exp7", "exp8", "exp9"].join("|")).test(s)
    );
    this.setState(p => ({ ...p, todo, status: Status.READY }));
  }

  select = (idx: number) => {
    const { todo } = this.state;
    const exid = todo[idx];
    this.setState(p => ({
      ...p,
      todo,
      exid,
      status: Status.READY,
      seed: Date.now(),
      err: null
    }));
  };

  run = async () => {
    this.setState(s => Object.assign(s, { status: Status.RUNNING }));

    const { exid } = this.state;
    const script = "PreStrioAnalysis_select_regions";

    // TODO how to handle file ext not available?
    try {
      const { experiment, slice } = await db.findEx(exid);
      const imageName = extra.utils.getImage(slice, Ext.Strio);
      const img = `${config.IMAGES_FOLDER}/${experiment}/${imageName}`;
      await runMatlab(this.name, exid, script, [img]);
    } catch (err) {
      if (err) {
        this.setState(p => ({ ...p, err: err.toString() }));
        logger.error(err.toString(), "PreStrioAnalysis");
      }
    }

    this.setState(p => ({ ...p, status: Status.CONFIRM, seed: Date.now() }));
  };

  complete = async () => {
    const { exid, todo } = this.state;

    await writeDone(this.name, exid);

    const exidIdx = todo.indexOf(exid);
    const todoNew = todo
      .slice(0, exidIdx)
      .concat(todo.slice(exidIdx + 1, todo.length));
    this.setState(p => ({
      ...p,
      exid: todoNew[exidIdx],
      todo: todoNew,
      seed: Date.now(),
      err: null,
      status: Status.READY
    }));
  };

  renderConfirm() {
    const dir = getDir(this.name);
    const original = `${dir}/tmp/${this.state.exid}-original.png`;
    const regionsRemoved = `${dir}/tmp/${this.state.exid}-regions-removed.png`;
    const sz = 600;

    return (
      <div>
        <div
          style={{ display: "flex", flex: 1, justifyContent: "space-around" }}
        >
          <img src={original} width={sz} height={sz} />
          <img
            src={`${regionsRemoved}?${this.state.seed}`}
            width={sz}
            height={sz}
          />
        </div>
        <Button onClick={this.complete}>Confirm</Button>
        <Button onClick={this.run}>Redo</Button>
      </div>
    );
  }

  renderSubview() {
    switch (this.state.status) {
      case Status.LOADING:
        return <h3> Loading... </h3>;
      case Status.RUNNING:
        return <h3> Running... </h3>;
      case Status.CONFIRM:
        if (this.state.err !== null) {
          return <h3> Error {this.state.err}</h3>;
        }
        return this.renderConfirm();
      case Status.READY:
        return <Button onClick={this.run}>Run</Button>;
    }
  }

  render() {
    return (
      <div>
        <h3>{this.state.todo.length} item(s) to do</h3>
        <Selector
          default={"Select an item"}
          names={this.state.todo}
          onChange={idx => this.select(idx)}
        />
        <br />
        {this.renderSubview()}
      </div>
    );
  }
}
