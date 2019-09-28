import * as React from "react";

import ImageZoom from "../../../../../components.common/ImageZoom";
import { ValMap, Pos } from "../../types";
import { getImgSrc } from "../../utils";
import { IMG_SIZE } from "../../consts";

interface P {
  exid: string;
  map: ValMap;
  pos: Pos;
  dir: string;
  zoomID: string;
}

const ZOOM_FACTOR = 3;

class ImagesView extends React.Component<P> {
  constructor(props: P) {
    super(props);
  }

  render() {
    const { exid, map, pos, dir, zoomID } = this.props;
    const { imgsrc, imgog } = getImgSrc(exid, dir, pos, map);

    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        <ImageZoom
          src={imgog}
          width={IMG_SIZE}
          height={IMG_SIZE}
          zoomfact={ZOOM_FACTOR}
          zoomID={zoomID}
        />
        <ImageZoom
          src={imgsrc}
          width={IMG_SIZE}
          height={IMG_SIZE}
          zoomfact={ZOOM_FACTOR}
          zoomID={zoomID}
        />
      </div>
    );
  }
}

export default ImagesView;
