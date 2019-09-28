import * as React from "react";
import { Button } from "semantic-ui-react";

import Canvas from "./Canvas";
import { MaskMap, Pos, Mask } from "../../types";
import { IMG_SIZE } from "../../consts";

interface P {
  imgsrc: string;
  pos: Pos;
  masks: MaskMap;
  updateMaskMap: (data: Mask) => void;
}

class SpinesMasking extends React.Component<P> {
  canvas: React.RefObject<Canvas>;

  constructor(props: P) {
    super(props);
    this.canvas = React.createRef();
  }

  clearMask = () => {
    this.canvas.current.clearCanvas();
    this.updateMaskMap();
  };

  updateMaskMap = () => {
    const data = this.canvas.current.getCanvasData();
    this.props.updateMaskMap(data);
  };

  render() {
    const { imgsrc, pos } = this.props;
    const [r, c] = pos;
    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        <img id="img" src={imgsrc} width={IMG_SIZE} height={IMG_SIZE} />
        <div style={{ flex: 1 }}>
          <Canvas
            init={this.props.masks.get(`${r}#${c}`)}
            ref={this.canvas}
            imsrc={imgsrc}
            onmouseup={this.updateMaskMap}
          />
        </div>
        <Button basic onClick={this.clearMask}>
          Clear
        </Button>
      </div>
    );
  }
}

export default SpinesMasking;
