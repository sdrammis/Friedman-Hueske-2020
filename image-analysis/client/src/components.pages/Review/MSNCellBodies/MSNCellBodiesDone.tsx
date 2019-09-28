import * as React from "react";
import * as fs from "mz/fs";

import Selector from "../../../components.common/Selector";
import { getDir, rerun } from "../utils";

const IMG_SIDE_LEN = 800;

interface CompState {
  executions: string[];
  isLoading: boolean;
  selectedEx: string | null;
  selectedThresh: number | null;
}

export default class MSNCellBodiesDone extends React.Component<{}, CompState> {
  dir: string;

  constructor(props: {}) {
    super(props);

    this.state = {
      executions: [],
      isLoading: true,
      selectedEx: null,
      selectedThresh: null
    };
    this.dir = getDir("msn_cell_body_detection");
  }

  componentWillMount() {
    this.load();
  }

  async load() {
    const executions = (await fs.readdir(`${this.dir}/done`))
      .filter(f => f.includes("-done.txt"))
      .map(f => f.split("-done.txt")[0]);
    this.setState(p => Object.assign(p, { executions, isLoading: false }));
  }

  selectEx = async (exid: string) => {
    this.setState(p =>
      Object.assign(p, {
        selectedEx: null,
        selectedThresh: null,
        isLoading: false
      })
    );

    const b = await fs.readFile(`${this.dir}/done/${exid}-data.json`);
    const { thresholds, selected } = JSON.parse(b.toString());
    const selectedThresh = thresholds[selected - 1];

    this.setState(p => Object.assign(p, { selectedEx: exid, selectedThresh }));
  };

  rerun = () => {
    rerun(this.dir, this.state.selectedEx, () => {
      const { selectedEx, executions } = this.state;
      const exidIdx = executions.indexOf(selectedEx);
      const executionsNew = executions
        .slice(0, exidIdx)
        .concat(executions.slice(exidIdx + 1, executions.length));
      this.setState(p => ({
        ...p,
        selected: [null, null, null, null],
        selectedEx: executionsNew[Math.min(exidIdx, executionsNew.length - 1)],
        executions: executionsNew
      }));
    });
  };

  renderExecution() {
    const { selectedEx, selectedThresh } = this.state;
    const imgSrc = `${this.dir}/done/${selectedEx}.png`;
    return (
      <div>
        <h4>{this.state.selectedEx}</h4>
        <h3>Threshold: {selectedThresh}</h3>
        <button onClick={this.rerun}>Rerun</button>
        <img src={imgSrc} width={IMG_SIDE_LEN} height={IMG_SIDE_LEN} />
      </div>
    );
  }

  render_() {
    const { executions, selectedEx } = this.state;
    return (
      <div>
        <Selector
          default={"------------"}
          names={executions}
          onChange={idx => this.selectEx(executions[idx])}
        />
        {selectedEx ? this.renderExecution() : null}
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
