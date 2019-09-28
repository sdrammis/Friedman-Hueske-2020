import * as React from "react";

import ButtonGroup from "../../../components.common/ButtonGroup";
import MSNCellBodiesManual from "./MSNCellBodiesManual";
import MSNCellBodiesDone from "./MSNCellBodiesDone";

enum View {
  Manual,
  Done
}

interface CompState {
  view: View;
}

const VIEWS = [View.Manual, View.Done];

class MSNCellBodyDetection extends React.Component<{}, CompState> {
  name = "msn_cell_body_detection";

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
        return <MSNCellBodiesManual />;
      case View.Done:
        return <MSNCellBodiesDone />;
      default:
        return <div> Something went wrong. </div>;
    }
  }

  renderButton(name: string, view: View) {
    const style =
      this.state.view === view ? { backgroundColor: "green" } : null;
    return (
      <button style={style} onClick={() => this.setView(view)}>
        {name}
      </button>
    );
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

export default MSNCellBodyDetection;
