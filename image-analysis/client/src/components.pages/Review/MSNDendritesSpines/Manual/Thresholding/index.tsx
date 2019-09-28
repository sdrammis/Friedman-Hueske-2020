import * as React from "react";

import SelectionMap from "../../Shared/SelectionMap";
import ImagesView from "./ImagesView";
import MetadataView from "../../Shared/MetadataView";
import { ValMap, Metadata, Pos } from "../../types";
import { NUM_COLS, NUM_ROWS } from "../../consts";
import * as utils from "./utils";
import { updatePos } from "../../utils";

const ZOOM_ID = "zoom-div";

interface P {
  dir: string;
  exid: string | null;
  pos: Pos;
  map: ValMap;
  metadata: Metadata;
  setPos: (p: Pos) => void;
  setMap: (m: ValMap) => void;
}

class SpinesThresholding extends React.Component<P> {
  constructor(props: P) {
    super(props);

    this.state = {};
  }

  componentWillMount() {
    document.onkeydown = this.onKeyPress;
  }

  onKeyPress = (e: any) => {
    const { exid, pos, map } = this.props;
    if (exid === null) {
      return;
    }

    const n = this.props.metadata.dendThreshs.length;
    const keycode = (e || window.event).keyCode;
    const posKeys = [78, 80];

    if (posKeys.includes(keycode)) {
      const newPos = updatePos(NUM_ROWS, NUM_COLS, pos, keycode);
      this.props.setPos(newPos);
    } else {
      const newMap = utils.updateMap(map, pos, keycode, n);
      this.props.setMap(newMap);
    }
  };

  renderWork() {
    const { map, pos, exid, dir } = this.props;
    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        <ImagesView
          exid={exid}
          map={map}
          pos={pos}
          dir={dir}
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
          <div id={ZOOM_ID} style={{ position: "absolute", top: 0, left: 0 }} />
        </div>
      </div>
    );
  }

  renderExecution() {
    const { exid, pos, map, metadata } = this.props;
    if (exid === null) {
      return;
    }

    return (
      <div>
        <MetadataView metadata={metadata} pos={pos} map={map} />
        {this.renderWork()}
      </div>
    );
  }

  render() {
    return this.renderExecution();
  }
}

export default SpinesThresholding;
