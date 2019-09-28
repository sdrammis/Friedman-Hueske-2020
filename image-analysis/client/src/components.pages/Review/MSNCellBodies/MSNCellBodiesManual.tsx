import * as React from "react";
import * as fs from "mz/fs";
// @ts-ignore
import ReactImageMagnify from "react-image-magnify";

import Selector from "../../../components.common/Selector";
import { getManualWork, writeDone, getDir, rerun } from "../utils";
import logger from "../../../logger";

const NUM_THRESHOLDS = 3;
const IMG_SIZE = 600;
const ZOOM_FACTOR = 4;

interface CompState {
  todo: string[];
  exid: string | null;
  thresholds: number[] | null;
  selected: number | null;
  isLoading: boolean;
}

class MSNCellBodyDetectionManual extends React.Component<{}, CompState> {
  dir: string;
  name = "msn_cell_body_detection";

  constructor(props: {}) {
    super(props);

    this.dir = getDir(this.name);
    this.state = {
      todo: [],
      exid: null,
      selected: null,
      thresholds: null,
      isLoading: true
    };
  }

  async load() {
    const todo = await getManualWork(this.name);
    this.setState(p => ({ ...p, todo, isLoading: false }));
  }

  componentWillMount() {
    this.load();
  }

  select = async (idx: number) => {
    const { todo } = this.state;
    const exid = todo[idx];

    const b = await fs.readFile(`${this.dir}/manual/${exid}-data.json`);
    const { thresholds } = JSON.parse(b.toString());

    this.setState(p => ({ ...p, todo, exid, thresholds }));
  };

  submit = async () => {
    const { exid, selected } = this.state;

    await fs.copyFile(
      `${this.dir}/manual/${exid}-${selected}-data.mat`,
      `${this.dir}/done/${exid}-data.mat`,
      e => {
        if (e) logger.error(e.message, this.name);
      }
    );
    await fs.copyFile(
      `${this.dir}/manual/${exid}-${selected}.png`,
      `${this.dir}/done/${exid}.png`,
      e => {
        if (e) logger.error(e.message, this.name);
      }
    );

    const b = await fs.readFile(`${this.dir}/manual/${exid}-data.json`);
    const { thresholds } = JSON.parse(b.toString());
    await fs.writeFile(
      `${this.dir}/done/${exid}-data.json`,
      JSON.stringify({ selected, thresholds })
    );

    await writeDone(this.name, exid);
    this.getNext();
  };

  getNext = () => {
    const { exid, todo } = this.state;

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

  rerun = () => {
    rerun(this.dir, this.state.exid, this.getNext);
  };

  renderThreshold(k: number) {
    const dir = `${this.dir}/manual`;
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
        <div
          style={{
            display: "flex",
            flexDirection: "row",
            alignItems: "center"
          }}
        >
          <h3> Thresholds: {this.state.thresholds.join(", ")}</h3>
          <div style={{ padding: 10 }}>
            <button onClick={this.rerun}> Re-Run Slice </button>
          </div>
        </div>
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
        <Selector
          default={"------------"}
          names={this.state.todo}
          onChange={idx => this.select(idx)}
        />
        {this.renderThresholdGrid()}
      </div>
    );
  }

  render_() {
    return (
      <div>
        {this.state.isLoading ? <h3> Loading... </h3> : this.renderSubview()}
      </div>
    );
  }

  render() {
    return this.render_();
  }
}

export default MSNCellBodyDetectionManual;
