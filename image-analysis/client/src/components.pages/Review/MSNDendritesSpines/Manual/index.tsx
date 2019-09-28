import * as React from "react";
import * as fs from "mz/fs";
import { Divider, Button } from "semantic-ui-react";

import Selector from "../../../../components.common/Selector";
import ButtonGroup from "../../../../components.common/ButtonGroup";
import { Pos, ValMap, Metadata, MaskMap, Mask } from "../types";
import { getDir, getManualWork, reselect, rerun } from "../../utils";
import { getImgSrc } from "../utils";
import * as utils from "./utils";
import Thresholding from "./Thresholding";
import Masking from "./Masking";
import { NAME } from "../consts";

enum View {
  Loading,
  Thresholding,
  Masking
}

interface S {
  todo: string[];
  exid: string | null;
  pos: Pos;
  map: ValMap;
  metadata: Metadata;
  view: View;
}

const VIEWS = [View.Thresholding, View.Masking];
const DEFAULT = 0;

class MSNDendritesSpinesManual extends React.Component<{}, S> {
  masks: MaskMap;
  dir: string;

  constructor(props: {}) {
    super(props);

    this.state = this.getInitState();
    this.masks = new Map();
    this.dir = getDir(NAME);
  }

  getInitState(): S {
    return {
      todo: [],
      exid: null,
      pos: [1, 1],
      map: new Map(),
      metadata: null,
      view: View.Loading
    };
  }

  componentWillMount() {
    this.load();
  }

  async load() {
    const todo = await getManualWork(NAME);
    this.setState(p => ({ ...p, todo, view: VIEWS[DEFAULT] }));
  }

  rerun = async () => {
    rerun(this.dir, this.state.exid, async () => {
      this.setState(p => ({ ...this.getInitState(), view: p.view }), this.load);
    });
  };

  updateMaskMap = (data: Mask) => {
    const [r, c] = this.state.pos;
    this.masks = this.masks.set(`${r}#${c}`, { ...data });
  };

  async select(idx: number) {
    const { todo } = this.state;
    const { dir } = this;

    const exid = todo[idx];
    const buff = await fs.readFile(`${dir}/manual/${exid}-data.json`);
    const metadata = JSON.parse(buff.toString());
    const initState = this.getInitState();

    const threshFile = `${dir}/done/${exid}-threshs.json`;
    let map = new Map();
    if (await fs.exists(threshFile)) {
      const threshBuff = await fs.readFile(threshFile);
      const prevThreshs = JSON.parse(threshBuff.toString());
      const { regionMaskMap, regionThreshMap } = prevThreshs;
      const masks = new Map(regionMaskMap) as MaskMap;
      map = new Map(regionThreshMap) as ValMap;
      this.masks = masks;
    }

    this.setState(p => ({
      ...p,
      ...initState,
      todo: todo,
      view: View.Thresholding,
      exid,
      metadata,
      map
    }));
  }

  submit = async () => {
    const { dir } = this;
    const { exid, todo, map, metadata } = this.state;

    await utils.submit(dir, NAME, exid, map, this.masks, metadata);
    const next = await utils.getNextEx(dir, exid, todo);
    const initState = this.getInitState();

    this.setState(p => ({
      ...p,
      ...initState,
      view: View.Thresholding,
      exid: next.todoNew[todo.indexOf(exid)],
      todo: next.todoNew,
      metadata: next.metadataNew
    }));
  };

  setPos = (pos: Pos) => {
    this.setState(p => ({ ...p, pos }));
  };

  setMap = (map: ValMap) => {
    this.setState(p => ({ ...p, map }));
  };

  setMasks = (masks: MaskMap) => {
    this.setState(p => ({ ...p, masks }));
  };

  renderView() {
    const { view, pos, exid, map } = this.state;
    const { imgsrc } = getImgSrc(exid, this.dir, pos, map);

    switch (view) {
      case View.Thresholding:
        return (
          <Thresholding
            setPos={this.setPos}
            setMap={this.setMap}
            {...this.state}
            dir={this.dir}
          />
        );
      case View.Masking:
        return (
          <Masking
            masks={this.masks}
            pos={pos}
            imgsrc={imgsrc}
            updateMaskMap={this.updateMaskMap}
          />
        );
    }
  }

  renderExecution() {
    return (
      <div>
        <Divider />
        <ButtonGroup
          names={["Thresholding", "Masking"]}
          default={DEFAULT}
          onChange={idx => this.setState(p => ({ ...p, view: VIEWS[idx] }))}
        />
        <div style={{ paddingTop: "20px" }}>{this.renderView()}</div>
        <Button onClick={this.submit}> Submit </Button>
      </div>
    );
  }

  renderSelector() {
    const { exid } = this.state;
    return (
      <div
        style={{
          display: "flex",
          flex: 1,
          flexDirection: "row",
          justifyContent: "space-between"
        }}
      >
        <Selector
          default={"------------"}
          names={this.state.todo}
          onChange={idx => this.select(idx)}
        />
        {exid ? <Button onClick={this.rerun}>Rerun</Button> : null}
      </div>
    );
  }

  render() {
    const { view, todo, exid } = this.state;
    if (view === View.Loading) {
      return <h3> Loading... </h3>;
    }

    return (
      <div style={{ paddingTop: "20px" }}>
        <h3>{todo.length} item(s) to do</h3>
        {this.renderSelector()}
        {exid ? this.renderExecution() : null}
      </div>
    );
  }
}

export default MSNDendritesSpinesManual;
