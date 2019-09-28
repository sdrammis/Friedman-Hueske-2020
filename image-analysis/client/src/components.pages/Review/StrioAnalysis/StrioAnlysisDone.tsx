import * as React from "react";
import * as fs from "mz/fs";

import Selector from "../../../components.common/Selector";
import Grid from "../../../components.common/Grid";
import { getDir } from "../utils";
import { rerunIdent, rerunDraw } from "./utils";
import { name as preStrioAnalysisName } from "../PreStrioAnalysis";

const IMG_SIDE_LEN = 400;

interface CompState {
  executions: string[];
  isLoading: boolean;
  selectedEx: {
    exid: string;
    allThreshs: { thresholds1: number[]; thresholds2: number[] };
    selectedThreshs: [number, number][]; // [row, col]
  } | null;
}

export default class StrioAnalysisDone extends React.Component<{}, CompState> {
  dir: string;

  constructor(props: {}) {
    super(props);

    this.state = {
      executions: [],
      isLoading: true,
      selectedEx: null
    };
    this.dir = getDir("strio_analysis");
  }

  componentWillMount() {
    this.load();
  }

  selectItem = async (itemIdx: number) => {
    const exid = this.state.executions[itemIdx];
    const allThreshs = JSON.parse(
      (await fs.readFile(`${this.dir}/manual/${exid}-threshs.json`)).toString()
    );
    const chosenThreshs = JSON.parse(
      (await fs.readFile(`${this.dir}/done/${exid}-threshs.json`)).toString()
    );

    const selectedThreshs: [number, number][] = [];
    Object.keys(chosenThreshs).forEach((k, i) => {
      const { thresh1, thresh2 } = chosenThreshs[k];
      if (thresh1 === null) {
        return;
      }

      for (let j = 0; j < allThreshs.thresholds1.length; j++) {
        const t1 = allThreshs.thresholds1[j];
        const t2 = allThreshs.thresholds2[j];
        if (thresh1 === t1 && thresh2 === t2) {
          selectedThreshs.push([i, j]);
          break;
        }
      }
    });

    this.setState(p =>
      Object.assign(p, { selectedEx: { exid, allThreshs, selectedThreshs } })
    );
  };

  async load() {
    const executions = (await fs.readdir(`${this.dir}/done`))
      .filter(f => f.includes("-done.txt"))
      .map(f => f.split("-done.txt")[0]);
    this.setState(p => Object.assign(p, { executions, isLoading: false }));
  }

  getNext = () => {
    const { selectedEx, executions } = this.state;
    const exid = selectedEx.exid;

    const exidIdx = executions.indexOf(exid);
    const executionsNew = executions
      .slice(0, exidIdx)
      .concat(executions.slice(exidIdx + 1, executions.length));
    this.setState(
      p => ({
        ...p,
        selectedEx: null,
        executions: executionsNew
      }),
      () => this.selectItem(exidIdx)
    );
  };

  renderSelectionImage(exid: string, r: string, c: string) {
    const { selectedThreshs } = this.state.selectedEx;
    const style =
      c !== "original" &&
      selectedThreshs
        .map(s => JSON.stringify(s))
        .indexOf(JSON.stringify([parseInt(r) - 1, parseInt(c) - 1])) >= 0
        ? { backgroundColor: "#05ff00" }
        : null;

    if (c !== "original") {
      [r, c] = [c, r];
    }
    return (
      <img
        src={`${this.dir}/manual/${exid}-${c}-${r}.png`}
        style={{ ...style, padding: "5px" }}
        width={IMG_SIDE_LEN}
        height={IMG_SIDE_LEN}
      />
    );
  }

  renderSelectionThreshold(c: string) {
    if (c === "original") {
      return <h3> Thresholds: (threhsold 1, threshold 2)</h3>;
    }

    const { thresholds1, thresholds2 } = this.state.selectedEx.allThreshs;
    return (
      <h3 style={{ textAlign: "center" }}>
        ({thresholds1[parseInt(c) - 1]}, {thresholds2[parseInt(c) - 1]})
      </h3>
    );
  }

  renderSelection() {
    const { exid } = this.state.selectedEx;
    const rowVals = ["threshold", "1", "2", "3", "4"];
    const colVals = ["original", "1", "2", "3"];
    const cb = (c: string, r: string) => {
      if (r === "threshold") {
        return this.renderSelectionThreshold(c);
      }
      return this.renderSelectionImage(exid, r, c);
    };

    return <Grid colVals={colVals} rowVals={rowVals} cb={cb} />;
  }

  renderExecution() {
    if (this.state.selectedEx === null) {
      return;
    }

    const { exid } = this.state.selectedEx;
    const preDir = getDir(preStrioAnalysisName);
    return (
      <div>
        <button onClick={() => rerunIdent(this.dir, exid, this.getNext)}>
          Rerun Strio Identification
        </button>
        <button onClick={() => rerunDraw(this.dir, preDir, exid, this.getNext)}>
          Rerun Strio Drawing
        </button>

        {this.renderSelection()}
      </div>
    );
  }

  render_() {
    const { executions } = this.state;
    return (
      <div>
        <Selector
          default={"------------"}
          names={this.state.executions}
          onChange={idx => this.selectItem(idx)}
        />
        {this.renderExecution()}
      </div>
    );
  }

  render() {
    if (this.state.isLoading) {
      return <h1> Loading Done... </h1>;
    }
    return this.render_();
  }
}
