import * as React from "react";
import { Container, Divider } from "semantic-ui-react";

import ButtonGroup from "../../components.common/ButtonGroup";
import PreStrioAnalysis from "./PreStrioAnalysis";
import StrioAnalysis from "./StrioAnalysis";
import MSNCellBodyDetection from "./MSNCellBodies";
import MSNDendriteSpines from "./MSNDendritesSpines";
import PVCellBodyDetection from "./PVCellBodies";
import PVDendriteDetection from "./PVDendrites";

enum Subview {
  PreStrioAnalysis,
  StrioAnalysis,
  MSNCellBodyDetection,
  MSNDendriteSpines,
  PVCellBodyDetection,
  PVDendriteDetection
}

interface CompState {
  subview: Subview | null;
}

const VIEW_NAMES = [
  "Strio Cutting",
  "Strio Identification",
  "MSN Cell Body Detection",
  "MSN Dendrite and Spines Detection",
  "PV Cell Body Detection",
  "PV Dendrites Detection"
];

const VIEWS = [
  Subview.PreStrioAnalysis,
  Subview.StrioAnalysis,
  Subview.MSNCellBodyDetection,
  Subview.MSNDendriteSpines,
  Subview.PVCellBodyDetection,
  Subview.PVDendriteDetection
];

const DEFAULT = 3;

export default class Executions extends React.Component<{}, CompState> {
  constructor(props: {}) {
    super(props);

    this.state = { subview: VIEWS[DEFAULT] };
  }

  setSubview(subview: Subview) {
    this.setState(p => ({ ...p, subview }));
  }

  renderButton(name: string, subview: Subview) {
    const backgroundColor =
      this.state.subview === subview ? "#0088bb" : "#eeeeee";
    return (
      <button
        style={{ backgroundColor }}
        onClick={() => this.setSubview(subview)}
      >
        {name}
      </button>
    );
  }

  renderNav() {
    return (
      <ButtonGroup
        names={VIEW_NAMES}
        default={DEFAULT}
        onChange={idx => this.setState(p => ({ ...p, subview: VIEWS[idx] }))}
      />
    );
  }

  renderSubview() {
    switch (this.state.subview) {
      case Subview.PreStrioAnalysis:
        return <PreStrioAnalysis />;
      case Subview.StrioAnalysis:
        return <StrioAnalysis />;
      case Subview.MSNCellBodyDetection:
        return <MSNCellBodyDetection />;
      case Subview.MSNDendriteSpines:
        return <MSNDendriteSpines />;
      case Subview.PVCellBodyDetection:
        return <PVCellBodyDetection />;
      case Subview.PVDendriteDetection:
        return <PVDendriteDetection />;
      default:
        return VIEWS[DEFAULT];
    }
  }

  render() {
    return (
      <Container>
        {this.renderNav()}
        <Divider />
        <div>{this.renderSubview()}</div>
      </Container>
    );
  }
}
