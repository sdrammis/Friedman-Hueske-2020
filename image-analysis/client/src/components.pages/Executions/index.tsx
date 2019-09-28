import * as React from "react";
import * as fs from "mz/fs";
const mkdirpPromise = require("mkdirp-promise"); // no typings
import { Execution } from "striomatrix-cv-extra";
import { Segment, Container } from "semantic-ui-react";

import db from "../../db";
import Table from "./Table";
import Form from "./Form";
import config from "../../../config";

export interface CompState {
  executions: Execution[];
  rand: number;
}

export default class Executions extends React.Component<{}, CompState> {
  constructor(props: {}) {
    super(props);

    this.state = {
      executions: [],
      rand: 0
    };
  }

  componentWillMount() {
    this.loadExecutions();
  }

  async loadExecutions() {
    const executions = await db.listExs();
    this.setState(p => ({
      ...p,
      executions,
      rand: Math.random()
    }));
  }

  createExecution = async (
    data: { exp: string; slice: string },
    exid: string
  ) => {
    const rootDirs = [
      { name: "pre_strio_analysis", folder: "manual" },
      { name: "pre_strio_analysis_2", folder: "done" },
      { name: "pre_msn_cell_body_detection", folder: "done" },
      { name: "pre_cortex_input_detection", folder: "done" },
      { name: "pre_pv_cell_body_detection", folder: "done" },
      { name: "pre_pv_dendrite_detection", folder: "done" }
    ];

    const exids = this.state.executions.map(e => e.exid.toLowerCase());
    if (exids.includes(exid.toLowerCase())) {
      return;
    }

    await db.newEx(exid, data.exp, data.slice);
    await Promise.all(
      rootDirs.map(async ({ name, folder }) => {
        const dir = `${config.FS_ROOT}/${name}`;
        await mkdirpPromise(`${dir}/done`);
        await mkdirpPromise(`${dir}/manual`);
        await mkdirpPromise(`${dir}/tmp`);
        await fs.writeFile(`${dir}/${folder}/${exid}-done.txt`, "");
      })
    );
    this.loadExecutions();
  };

  renderExecutions() {
    const titles = ["ID", "Experiment", "Slice", "Created At"];
    return (
      <div>
        <h2>Executions</h2>
        <Table
          titles={titles}
          items={this.state.executions.map(e => [
            e.exid,
            e.experiment,
            e.slice,
            e.createdAt.toString()
          ])}
        />
      </div>
    );
  }

  render() {
    return (
      <div key={this.state.rand}>
        <Container>
          <Segment>
            <Form onSubmit={this.createExecution} />
          </Segment>
          {this.renderExecutions()}
        </Container>
      </div>
    );
  }
}
