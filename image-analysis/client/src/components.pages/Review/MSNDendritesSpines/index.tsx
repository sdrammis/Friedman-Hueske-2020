import * as React from "react";

import ButtonGroup from "../../../components.common/ButtonGroup";
import MSNDendritesSpinesManual from "./Manual";
import MSNDendritesSpinesDone from "./Done";
import { getDir } from "../utils";
import { NAME } from "./consts";

enum View {
  Manual,
  Done
}

interface CompState {
  view: View;
}

const VIEWS = [View.Manual, View.Done];
const DEFAULT = 0;

class MSNDendritesSpines extends React.Component<{}, CompState> {
  name = NAME;
  dir: string;

  constructor(props: {}) {
    super(props);

    this.state = { view: VIEWS[DEFAULT] };
    this.dir = getDir(name);
  }

  setView = (view: View) => {
    this.setState(p => Object.assign(p, { view }));
  };

  renderView() {
    switch (this.state.view) {
      case View.Manual:
        return <MSNDendritesSpinesManual />;
      case View.Done:
        return <MSNDendritesSpinesDone />;
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
          default={DEFAULT}
          onChange={idx => this.setView(VIEWS[idx])}
        />
        {this.renderView()}
      </div>
    );
  }
}

export default MSNDendritesSpines;
