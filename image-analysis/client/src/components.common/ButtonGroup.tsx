import * as React from "react";
import { Button } from "semantic-ui-react";

interface P {
  names: string[];
  default: number;
  onChange: (idx: number) => void;
}

interface S {
  selected: number;
}

export default class ButtonGroup extends React.Component<P, S> {
  constructor(props: P) {
    super(props);

    this.state = {
      selected: props.default
    };
  }

  select(idx: number) {
    this.setState(
      p => ({ ...p, selected: idx }),
      () => {
        this.props.onChange(idx);
      }
    );
  }

  renderButton(name: string, idx: number) {
    return (
      <Button
        key={idx}
        onClick={this.select.bind(this, idx)}
        active={idx === this.state.selected}
      >
        {name}
      </Button>
    );
  }

  render() {
    return (
      <Button.Group>
        {this.props.names.map((name, idx) => this.renderButton(name, idx))}
      </Button.Group>
    );
  }
}
