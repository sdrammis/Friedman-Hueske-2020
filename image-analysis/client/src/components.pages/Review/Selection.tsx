import * as React from "react";
import * as fs from "mz/fs";
// @ts-ignore
import ReactImageMagnify from "react-image-magnify";

import { getManualWork, writeDone, getDir } from "./utils";
import logger from "../../logger";

const NUM_THRESHOLDS = 3;
const IMG_SIZE = 600;
const ZOOM_FACTOR = 4;

interface CompState {
  todo: string[];
  exid: string | null;
  selected: number | null;
  isLoading: boolean;
}

abstract class Selection extends React.Component<{}, CompState> {
  name: string;

  constructor(props: {}) {
    super(props);
    this.state = { todo: [], exid: null, selected: null, isLoading: true };
  }

  async load() {
    const todo = await getManualWork(this.name);
    this.setState(p => ({ ...p, todo, isLoading: false }));
  }

  componentWillMount() {
    this.load();
  }

  select(idx: number) {
    const { todo } = this.state;
    const exid = todo[idx];
    this.setState(p => ({ ...p, todo, exid }));
  }

  submit = async () => {
    const { exid, selected, todo } = this.state;
    const dir = getDir(this.name);
    await fs.copyFile(
      `${dir}/manual/${exid}-${selected}-data.mat`,
      `${dir}/done/${exid}-data.mat`,
      e => {
        if (e) logger.error(e.message, this.name);
      }
    );
    await fs.copyFile(
      `${dir}/manual/${exid}-${selected}.png`,
      `${dir}/done/${exid}.png`,
      e => {
        if (e) logger.error(e.message, this.name);
      }
    );
    await writeDone(this.name, exid);
    const exidIdx = todo.indexOf(exid);
    const todoNew = todo
      .slice(0, exidIdx)
      .concat(todo.slice(exidIdx + 1, todo.length));
    this.setState(p => ({
      ...p,
      selected: null,
      exid: todoNew[exidIdx],
      todo: todoNew
    }));
  };

  renderThreshold(k: number) {
    const dir = `${getDir(this.name)}/manual`;
    const isSelected = this.state.selected === k;
    const style = isSelected
      ? { borderColor: "green", borderWidth: "10px", borderStyle: "solid" }
      : null;

    const originalImg = `${dir}/${this.state.exid}-original.png`;
    const thresholdImg = `${dir}/${this.state.exid}-${k}.png`;
    const zoomID = `zoom-${k}`;

    return (
      <div key={k} style={{ display: "flex", flexDirection: "row" }}>
        <ReactImageMagnify
          smallImage={{
            src: originalImg,
            width: IMG_SIZE,
            height: IMG_SIZE
          }}
          largeImage={{
            src: originalImg,
            width: IMG_SIZE * ZOOM_FACTOR,
            height: IMG_SIZE * ZOOM_FACTOR
          }}
          enlargedImagePortalId={zoomID}
        />
        <div
          style={style}
          onClick={() => this.setState(p => Object.assign(p, { selected: k }))}
        >
          <ReactImageMagnify
            smallImage={{
              src: thresholdImg,
              width: IMG_SIZE,
              height: IMG_SIZE
            }}
            largeImage={{
              src: thresholdImg,
              width: IMG_SIZE * ZOOM_FACTOR,
              height: IMG_SIZE * ZOOM_FACTOR
            }}
            enlargedImagePortalId={zoomID}
          />
        </div>
        <div id={zoomID} />
      </div>
    );
  }

  renderThresholdGrid() {
    if (this.state.exid === null) {
      return null;
    }
    return (
      <div>
        <div style={{ display: "flex", flexDirection: "column" }}>
          {[...Array(NUM_THRESHOLDS).keys()].map(k =>
            this.renderThreshold(k + 1)
          )}
        </div>
        <button disabled={this.state.selected === null} onClick={this.submit}>
          Submit
        </button>
      </div>
    );
  }

  renderSubview() {
    const len = this.state.todo.length;
    return (
      <div>
        <h3>{len} item(s) to do</h3>
        <select onChange={event => this.select(parseInt(event.target.value))}>
          <option value={null} label="---------" />
          {this.state.todo.map((val, idx) => (
            <option key={idx} label={val} value={idx} />
          ))}
        </select>
        {this.renderThresholdGrid()}
      </div>
    );
  }

  render_() {
    return (
      <div>
        <h2>{this.name}</h2>
        {this.state.isLoading ? <h3> Loading... </h3> : this.renderSubview()}
      </div>
    );
  }

  render() {
    return this.render_();
  }
}

export default Selection;
