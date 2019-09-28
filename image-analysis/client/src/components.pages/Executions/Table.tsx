import * as React from "react";
import { css } from "aphrodite";

import style from "./style";

interface CompProps {
  titles: string[];
  items: string[][];
}

class ExecutionsForm extends React.Component<CompProps> {
  constructor(props: CompProps) {
    super(props);
  }

  render() {
    const { titles, items } = this.props;
    const tableCN = css(style.table);
    return (
      <table className={tableCN}>
        <thead>
          <tr>
            {titles.map((t, i) => (
              <th className={tableCN} key={i}>
                {t}
              </th>
            ))}
          </tr>
        </thead>
        <thead>
          {items.map((r, i) => (
            <tr key={i}>
              {r.map((c, j) => (
                <th className={tableCN} key={j}>
                  {c}
                </th>
              ))}
            </tr>
          ))}
        </thead>
      </table>
    );
  }
}

export default ExecutionsForm;
