import * as React from "react";

import { ValMap, Pos } from "../types";

interface P {
  numrows: number;
  numcols: number;
  pos: Pos;
  map: ValMap;
}

class SelectionMap extends React.Component<P> {
  constructor(props: P) {
    super(props);
  }

  renderRegion(r: number, c: number) {
    const { pos, map } = this.props;
    const thresh = map.get(`${r}#${c}`);
    const isCurrentRegion = pos[0] === r && pos[1] === c;
    return (
      <div
        key={`${r}#${c}`}
        style={{
          borderStyle: "solid",
          borderWidth: "1px",
          backgroundColor: isCurrentRegion ? "yellow" : null,
          width: 30,
          height: 30,
          textAlign: "center"
        }}
      >
        {thresh ? JSON.stringify(thresh) : "-"}
      </div>
    );
  }

  renderRow(r: number) {
    const cols = Array.from({ length: this.props.numcols }, (_, i) => ++i);
    return (
      <div key={r} style={{ display: "flex", flexDirection: "row" }}>
        {cols.map(c => this.renderRegion(r, c))}
      </div>
    );
  }

  render() {
    const rows = Array.from({ length: this.props.numrows }, (_, i) => ++i);
    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        {rows.map(r => this.renderRow(r))}
      </div>
    );
  }
}

export default SelectionMap;
