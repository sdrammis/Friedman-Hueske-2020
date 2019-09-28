import * as React from "react";
import { Dropdown, DropdownProps } from "semantic-ui-react";

interface P {
  default: string;
  names: string[];
  onChange: (idx: number) => void;
}

export default class Selector extends React.Component<P> {
  constructor(props: P) {
    super(props);
  }

  handlechange(
    _: React.SyntheticEvent<HTMLElement, Event>,
    data: DropdownProps
  ) {
    const idx = data.value as number;
    this.props.onChange(idx);
  }

  render() {
    const opts = this.props.names.map((name, idx) => ({
      key: idx,
      value: idx,
      text: name
    }));
    return (
      <Dropdown
        placeholder={this.props.default}
        selection
        options={opts}
        onChange={this.handlechange.bind(this)}
      />
    );
  }
}
