import * as React from "react";
import * as fs from "mz/fs";

import Selector from "../../../components.common/Selector";
import { getManualWork, getDir, writeDone } from "../utils";
import { name as preStrioAnalysisName } from "../PreStrioAnalysis";
import { rerunIdent, rerunDraw } from "./utils";

interface CompState {
  todo: string[];
  exid: string | null;
  thresholds: { thresholds1: string[]; thresholds2: string[] } | null;
  selected: (number | null)[];
  isLoading: boolean;
}

const NUM_THRESHOLDS = 3;
const IMG_SIZE = 400;

class StrioAnalysisManual extends React.Component<{}, CompState> {
  name = "strio_analysis";
  dir: string;

  constructor(props: {}) {
    super(props);

    this.dir = getDir(this.name);
    this.state = {
      todo: [],
      exid: null,
      thresholds: null,
      selected: [null, null, null, null],
      isLoading: true
    };
  }

  componentWillMount() {
    this.load();
  }

  async load() {
    const todo = await getManualWork(this.name);
    this.setState(p => ({ ...p, todo: todo, isLoading: false }));
  }

  selectEx = async (idx: number) => {
    const { todo } = this.state;
    const exid = todo[idx];
    const thresholds = JSON.parse(
      (await fs.readFile(`${this.dir}/manual/${exid}-threshs.json`)).toString()
    );
    this.setState(p => ({ ...p, todo, exid, thresholds }));
  };

  getNext = () => {
    const { exid, todo } = this.state;
    const exidIdx = todo.indexOf(exid);
    const todoNew = todo
      .slice(0, exidIdx)
      .concat(todo.slice(exidIdx + 1, todo.length));
    this.setState(p => ({
      ...p,
      selected: [null, null, null, null],
      exid: todoNew[Math.min(exidIdx, todoNew.length - 1)],
      todo: todoNew
    }));
  };

  submit = async () => {
    const { exid, selected } = this.state;
    const threshsBuff = await fs.readFile(
      `${this.dir}/manual/${exid}-threshs.json`
    );
    const threshsJSON = JSON.parse(threshsBuff.toString());

    const data = {} as any;
    selected.forEach((v, i) => {
      data[`region${i + 1}`] = {
        thresh1: v !== null ? threshsJSON.thresholds1[v - 1] : null,
        thresh2: v !== null ? threshsJSON.thresholds2[v - 1] : null
      };
    });

    await fs.writeFile(
      `${this.dir}/done/${exid}-threshs.json`,
      JSON.stringify(data)
    );
    await writeDone(this.name, exid);
    this.getNext();
  };

  renderImage(region: number, thresh: number) {
    const dir = `${this.dir}/manual`;
    const isSelected = this.state.selected[region - 1] === thresh;
    const style = isSelected
      ? { borderColor: "green", borderWidth: "10px", borderStyle: "solid" }
      : null;

    return (
      <img
        key={thresh}
        src={`${dir}/${this.state.exid}-${region}-${thresh}.png`}
        width={IMG_SIZE}
        height={IMG_SIZE}
        style={style}
        onClick={() => {
          const selected = this.state.selected.slice(0);
          selected[region - 1] = isSelected ? null : thresh;
          this.setState(p => Object.assign(p, { selected }));
        }}
      />
    );
  }

  renderRow(region: number) {
    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        <img
          src={`${this.dir}/manual/${this.state.exid}-original-${region}.png`}
          width={IMG_SIZE}
          height={IMG_SIZE}
        />
        {[...Array(NUM_THRESHOLDS).keys()].map(t =>
          this.renderImage(region, t + 1)
        )}
      </div>
    );
  }

  renderThresholds() {
    const { thresholds1, thresholds2 } = this.state.thresholds;

    return (
      <div
        style={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-around"
        }}
      >
        <h3> THRESHOLDS: </h3>
        {thresholds1.map((t1, i) => {
          const t2 = thresholds2[i];
          return (
            <h3 key={i}>
              ({t1}, {t2})
            </h3>
          );
        })}
      </div>
    );
  }

  renderSubview() {
    const { exid } = this.state;
    if (exid === null) {
      return null;
    }

    const preDir = getDir(preStrioAnalysisName);
    return (
      <div>
        <button onClick={() => rerunIdent(this.dir, exid, this.getNext)}>
          Rerun Strio Identification
        </button>
        <button onClick={() => rerunDraw(this.dir, preDir, exid, this.getNext)}>
          Rerun Strio Drawing
        </button>
        {this.renderThresholds()}
        {this.renderRow(1)}
        {this.renderRow(2)}
        {this.renderRow(3)}
        {this.renderRow(4)}
        <button onClick={this.submit}>Submit</button>
      </div>
    );
  }

  render_() {
    return (
      <div>
        <h3>{this.state.todo.length} item(s) to do</h3>
        <Selector
          default={"------------"}
          names={this.state.todo}
          onChange={idx => this.selectEx(idx)}
        />
        {this.renderSubview()}
      </div>
    );
  }

  render() {
    if (this.state.isLoading) {
      return <h1> Loading Manual... </h1>;
    }
    return this.render_();
  }
}

export default StrioAnalysisManual;
