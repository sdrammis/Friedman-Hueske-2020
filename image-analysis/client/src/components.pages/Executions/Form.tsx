import * as React from "react";
import * as fs from "mz/fs";
import { css } from "aphrodite";
import { Input, Divider, Button } from "semantic-ui-react";

import Selector from "../../components.common/Selector";
import style from "./style";
import config from "../../../config";
import { Execution } from "striomatrix-cv-extra";
import db from "../../db";

interface CompProps {
  onSubmit: (data: any, name: string) => void;
}

interface CompState {
  experiments: string[];
  slices: string[];
  experiment: string | null;
  slice: string | null;
  executions: Execution[];
}

class ExecutionsForm extends React.Component<CompProps, CompState> {
  constructor(props: CompProps) {
    super(props);

    this.state = {
      experiments: [],
      slices: [],
      experiment: null,
      slice: null,
      executions: []
    };
  }

  componentWillMount() {
    this.loadFolders();
  }

  async loadFolders() {
    const experiments = await fs.readdir(`${config.IMAGES_FOLDER}`);
    this.setState(p => Object.assign(p, { experiments }));
  }

  submit = () => {
    const { experiment, slice } = this.state;
    const data = { exp: experiment, slice: slice };
    const exid = (document.getElementById("input") as HTMLInputElement).value;
    this.props.onSubmit(data, exid);
  };

  selectExperiment = async (experiment: string) => {
    const files = (await fs.readdir(
      `${config.IMAGES_FOLDER}/${experiment}`
    )).filter(f => !f.startsWith("._"));

    const r = /(-fov [0-9]+)?((_|-)(msn|pv|hdprot|strio|vglut|allcells))?(_((-|\+)?[0-9]{0,10}))?(_\+[0-9]+.[0-9]+)?.(tiff|tif)$/;
    const slices = [...new Set(files.map(f => f.replace(r, "")))];
    this.setState(p => ({ ...p, experiment, slices, slice: null }));
  };

  renderExperimentSelector() {
    const { experiments } = this.state;
    return (
      <div className={css(style.selectorGroup)}>
        <h4> Experiment </h4>
        <Selector
          names={experiments}
          default={"-------------"}
          onChange={idx => this.selectExperiment(experiments[idx])}
        />
      </div>
    );
  }

  renderSliceSelector() {
    const { slices, experiment } = this.state;
    return (
      <div className={css(style.selectorGroup)}>
        <h4> Slice </h4>
        <Selector
          names={slices}
          default={"-------------"}
          onChange={async idx => {
            const slice = slices[idx];
            const executions = await db.find(experiment, slices[idx]);
            this.setState(p => ({ ...p, slice, executions }));
          }}
        />
      </div>
    );
  }

  render() {
    const { executions } = this.state;
    return (
      <div>
        <h2>Create Execution</h2>
        <div className={css(style.selectorContainer)}>
          {this.renderExperimentSelector()}
          {this.renderSliceSelector()}
        </div>

        <div style={{ padding: "20px" }}>
          <h3>Existing executions for slice: </h3>
          <p>
            {executions.length > 0
              ? executions.map(ex => ex.exid).join(", ")
              : "No executions"}
          </p>
        </div>

        <div className={css(style.selectorGroup)}>
          <h3>Execution name (unique): </h3>
          <Input id="input" type="text" />
        </div>

        <Button
          style={{ marginTop: "10px" }}
          onClick={this.submit}
          disabled={this.state.slice === null}
        >
          Create
        </Button>
      </div>
    );
  }
}

export default ExecutionsForm;
