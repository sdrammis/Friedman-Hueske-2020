import * as React from "react";
import * as fs from "mz/fs";
import Selection from "./Selection";
import { getManualWork, writeDone, getDir } from "./utils";
import logger from "../../logger";

const NUM_THRESHOLDS = 10;
const IMAGE_WDITH = 500;
const IMAGE_HEIGHT = 500;

interface CompState {
  todo: string[];
  exid: string | null;
  selected: boolean[];
  isLoading: boolean;
}

export default class PVDendrites extends React.Component<{}, CompState> {
  name = "pv_dendrite_detection";

  constructor(props: {}) {
    super(props);
    const selected = [...Array(NUM_THRESHOLDS)].map(_ => false);
    this.state = { todo: [], exid: null, selected, isLoading: true };
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

    await Promise.all(
      selected.map((s, i) => {
        if (!s) {
          return;
        }

        return fs.copyFile(
          `${dir}/manual/${exid}-${i}-data.mat`,
          `${dir}/done/${exid}-${i}-data.mat`,
          e => {
            if (e) logger.error(e.message, this.name);
          }
        );
      })
    );

    await writeDone(this.name, exid);
    const exidIdx = todo.indexOf(exid);
    const todoNew = todo
      .slice(0, exidIdx)
      .concat(todo.slice(exidIdx + 1, todo.length));
    this.setState(p => ({
      ...p,
      selected: [...Array(NUM_THRESHOLDS)].map(_ => false),
      exid: todoNew[exidIdx],
      todo: todoNew
    }));
  };

  renderThreshold(k: number) {
    const dir = `${getDir(this.name)}/manual`;
    const isSelected = this.state.selected[k];
    const style = isSelected
      ? { borderColor: "green", borderWidth: "10px", borderStyle: "solid" }
      : null;

    const wholeImage = `${dir}/${this.state.exid}-${k}.png`;
    const region1 = `${dir}/${this.state.exid}-${k}-1.png`;
    const region2 = `${dir}/${this.state.exid}-${k}-2.png`;
    const region3 = `${dir}/${this.state.exid}-${k}-3.png`;

    return (
      <div key={k} style={{ display: "flex", flexDirection: "column" }}>
        <div
          style={style}
          onClick={() =>
            this.setState(p => {
              const selectedNew = p.selected.slice();
              selectedNew[k - 1] = !p.selected[k - 1];
              Object.assign(p, { selected: selectedNew });
            })
          }
        >
          <img src={wholeImage} width={IMAGE_WDITH} height={IMAGE_HEIGHT} />
          <img src={region1} width={IMAGE_WDITH} height={IMAGE_HEIGHT} />
          <img src={region2} width={IMAGE_WDITH} height={IMAGE_HEIGHT} />
          <img src={region3} width={IMAGE_WDITH} height={IMAGE_HEIGHT} />
        </div>
      </div>
    );
  }

  renderThresholdGrid() {
    if (this.state.exid === null) {
      return null;
    }
    return (
      <div>
        <div style={{ display: "flex", flexDirection: "row" }}>
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
