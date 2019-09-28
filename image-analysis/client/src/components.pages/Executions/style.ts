import { StyleSheet } from "aphrodite";

export default StyleSheet.create({
  selectorGroup: {
    display: "flex",
    flex: 1,
    "flex-direction": "column",
    padding: "10px"
  },
  selectorContainer: {
    display: "flex",
    flex: 1,
    flexDirection: "row",
    justifyContent: "space-between"
  },
  table: {
    border: "1px solid black",
    padding: 5
  }
});
