import * as React from "react";
import * as fs from "mz/fs";
import { Divider, Button } from "semantic-ui-react";

import Selector from "../../../../components.common/Selector";
import { NUM_ROWS, NUM_COLS, IMG_SIZE, NAME } from "../consts";
import ImageZoom from "../../../../components.common/ImageZoom";
import { getImgSrc, updatePos } from "../utils";
import { getDir, rerun, reselect } from "../../utils";
import { Pos, ValMap, MaskMap, Metadata } from "../types";
import MetadataView from "../Shared/MetadataView";
import SelectionMap from "../Shared/SelectionMap";

const ZOOM_FACTOR = 3;
const ZOOM_ID = "div-zoom";
const IMG_DEFAULT = "https://react.semantic-ui.com/images/wireframe/image.png";

interface S {
  executions: string[];
  isLoading: boolean;
  exid: string | null;
  map: ValMap;
  masks: MaskMap;
  metadata: Metadata;
  pos: Pos;
  imgURI: string;
}

class MSNDendritesSpinesDone extends React.Component<{}, S> {
  dir: string;

  constructor(props: {}) {
    super(props);

    this.state = this.getInitState();
    this.dir = getDir(NAME);
  }

  getInitState(): S {
    return {
      executions: [],
      isLoading: true,
      map: new Map(),
      masks: new Map(),
      metadata: null,
      exid: null,
      pos: [1, 1],
      imgURI: null
    };
  }

  componentWillMount() {
    this.load();

    document.onkeydown = this.onKeyPress;
  }

  async load() {
    const executions = (await fs.readdir(`${this.dir}/done`))
      .filter(f => f.includes("-done.txt"))
      .map(f => f.split("-done.txt")[0]);
    this.setState(p => ({ ...p, executions, isLoading: false }));
  }

  rerun = async () => {
    rerun(this.dir, this.state.exid, async () => {
      this.setState(_ => this.getInitState(), this.load);
    });
  };

  reselect = async () => {
    await reselect(this.dir, this.state.exid);
    this.setState(_ => this.getInitState(), this.load);
  };

  loadCompositeImage = () => {
    const { exid, pos, map, masks } = this.state;
    const { imgsrc } = getImgSrc(exid, this.dir, pos, map);

    const mask = masks.get(`${pos[0]}#${pos[1]}`);
    if (mask === undefined) {
      this.setState(p => ({ ...p, imgURI: imgsrc }));
      return;
    }

    const image = document.createElement("img") as HTMLImageElement;
    image.width = IMG_SIZE;
    image.height = IMG_SIZE;
    image.src = imgsrc;

    const canvas = document.createElement("canvas");
    canvas.width = IMG_SIZE;
    canvas.height = IMG_SIZE;

    const context = canvas.getContext("2d");
    context.lineCap = "round";
    context.lineJoin = "round";
    context.strokeStyle = "blue";
    context.lineWidth = 20;
    context.clearRect(0, 0, IMG_SIZE, IMG_SIZE);

    image.onload = (_: Event) => {
      const { clickX, clickY, clickDrag } = mask;
      context.drawImage(image, 0, 0, IMG_SIZE, IMG_SIZE);
      for (let i = 0; i < clickX.length; ++i) {
        context.beginPath();
        if (clickDrag[i] && i) {
          context.moveTo(clickX[i - 1], clickY[i - 1]);
        } else {
          context.moveTo(clickX[i] - 1, clickY[i]);
        }
        context.lineTo(clickX[i], clickY[i]);
        context.stroke();
      }
      context.closePath();
      const imgURI = canvas.toDataURL();
      this.setState(p => ({ ...p, imgURI }));
    };
  };

  onKeyPress = async (e: any) => {
    const { exid, pos } = this.state;
    if (exid === null) {
      return;
    }

    const keycode = (e || window.event).keyCode;
    if (keycode === 78 || keycode === 80) {
      const newPos = updatePos(NUM_ROWS, NUM_COLS, pos, keycode);
      this.setState(p => ({ ...p, pos: newPos }), this.loadCompositeImage);
    }
  };

  async selectEx(exid: string) {
    const threshFile = `${this.dir}/done/${exid}-threshs.json`;
    const data = JSON.parse((await fs.readFile(threshFile)).toString());
    const metadata = data.regionData;
    const map = new Map(data.regionThreshMap) as ValMap;
    const masks = new Map(data.regionMaskMap) as MaskMap;
    this.setState(
      p => ({ ...p, exid, map, masks, metadata }),
      this.loadCompositeImage
    );
  }

  renderExecution() {
    const { exid, pos, map, metadata, imgURI } = this.state;
    if (exid === null) {
      return;
    }

    return (
      <div>
        <MetadataView {...{ pos, map, metadata }} />
        <div style={{ display: "flex", flexDirection: "row" }}>
          <ImageZoom
            src={imgURI || IMG_DEFAULT}
            width={IMG_SIZE}
            height={IMG_SIZE}
            zoomfact={ZOOM_FACTOR}
            zoomID={ZOOM_ID}
          />
          <div style={{ position: "relative" }}>
            <div style={{ position: "absolute", top: 0, left: 0 }}>
              <SelectionMap
                map={map}
                pos={pos}
                numrows={NUM_ROWS}
                numcols={NUM_COLS}
              />
            </div>
            <div
              id={ZOOM_ID}
              style={{ position: "absolute", top: 0, left: 0 }}
            />
          </div>
        </div>
      </div>
    );
  }

  renderSelector() {
    const { executions, exid } = this.state;
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
          default={"---------"}
          names={executions}
          onChange={idx => this.selectEx(executions[idx])}
        />
        {exid ? (
          <div>
            <Button onClick={this.reselect}>Reselect</Button>
            <Button onClick={this.rerun}>Rerun</Button>
          </div>
        ) : null}
      </div>
    );
  }

  render() {
    const { isLoading } = this.state;
    if (isLoading) {
      return <h1> Loading Done... </h1>;
    }

    return (
      <div style={{ paddingTop: 20 }}>
        {this.renderSelector()}
        <Divider />
        {this.renderExecution()}
      </div>
    );
  }
}

export default MSNDendritesSpinesDone;
