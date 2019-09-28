import * as React from "react";
import * as ReactDOM from "react-dom";
import "semantic-ui-css/semantic.min.css";

import { HashRouter as Router, Route, Link } from "react-router-dom";
import Executions from "./components.pages/Executions";
import Manual from "./components.pages/Review";

const Main = () => (
  <Router>
    <div>
      <ul>
        <li>
          <Link to="/">Executions</Link>
        </li>
        <li>
          <Link to="/manual">Manual</Link>
        </li>
      </ul>
      <hr />
      <Route exact path="/" component={Executions} />
      <Route exact path="/manual" component={Manual} />
    </div>
  </Router>
);

ReactDOM.render(Main(), document.getElementById("main"));
