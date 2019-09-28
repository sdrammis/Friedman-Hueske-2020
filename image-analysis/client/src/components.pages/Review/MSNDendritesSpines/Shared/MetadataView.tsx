import * as React from "react";

import { Pos, Metadata, ValMap } from "../types";

interface P {
  pos: Pos;
  map: ValMap;
  metadata: Metadata;
}

class MetadataView extends React.Component<P> {
  constructor(props: P) {
    super(props);
  }

  render() {
    const { pos, map, metadata } = this.props;
    const [row, col] = pos;
    const thresh = map.get(`${row}#${col}`);

    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        <h3 style={{ borderStyle: "solid", padding: 5 }}>
          Row: {row}, Col: {col}, Thresh: {thresh || "None"}
        </h3>
        <div style={{ marginLeft: 10 }}>
          <p> Dend Threshs: {metadata.dendThreshs.join(", ")} </p>
          <p> Spines Threshs: {metadata.spinesThreshs.join(", ")}</p>
        </div>
      </div>
    );
  }
}

export default MetadataView;
