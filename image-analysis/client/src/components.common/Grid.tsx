import * as React from "react";

interface CompProps {
  cb: (c: string, r: string) => JSX.Element;
  colVals: string[];
  rowVals: string[];
}

export default class ImageGrid extends React.Component<CompProps> {
  // Renders a grid, column values first.

  constructor(props: CompProps) {
    super(props);
  }

  renderItem(colVal: string, rowVal: string, rowIdx: number) {
    return <div key={rowIdx}>{this.props.cb(colVal, rowVal)}</div>;
  }

  renderCol(colVal: string, colIdx: number) {
    const { rowVals } = this.props;
    return (
      <div key={colIdx}>
        {rowVals.map((r, i) => this.renderItem(colVal, r, i))}
      </div>
    );
  }

  render() {
    const { colVals } = this.props;
    return (
      <div style={{ display: "flex", flexDirection: "row" }}>
        {colVals.map((c, i) => this.renderCol(c, i))}
      </div>
    );
  }
}
