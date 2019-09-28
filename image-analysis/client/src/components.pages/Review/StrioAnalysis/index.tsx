import * as React from "react";

import ButtonGroup from "../../../components.common/ButtonGroup";
import StrioAnalysisManual from "./StrioAnalysisManual";
import StrioAnalysisDone from "./StrioAnlysisDone";

enum View {
  Manual,
  Done
}

interface CompState {
  view: View;
}

const VIEWS = [View.Manual, View.Done];

class StrioAnalysis extends React.Component<{}, CompState> {
  name = "strio_analysis";

  constructor(props: {}) {
    super(props);

    this.state = { view: View.Manual };
  }

  setView = (view: View) => {
    this.setState(p => Object.assign(p, { view }));
  };

  renderView() {
    switch (this.state.view) {
      case View.Manual:
        return <StrioAnalysisManual />;
      case View.Done:
        return <StrioAnalysisDone />;
      default:
        return <div> Something went wrong. </div>;
    }
  }

  render() {
    return (
      <div>
        <ButtonGroup
          names={["Manual", "Done"]}
          default={0}
          onChange={idx => this.setView(VIEWS[idx])}
        />
        {this.renderView()}
      </div>
    );
  }
}

export default StrioAnalysis;
