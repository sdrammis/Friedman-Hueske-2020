import { ValMap, Pos } from "../../types";

export function updateMap(map: ValMap, pos: Pos, keycode: number, n: number) {
  const KEY_1 = 49;
  const KEY_0 = 48;

  let t;
  if (keycode === KEY_0) {
    t = null;
  } else {
    const val = keycode - KEY_1 + 1;
    if (val > 0 && val <= n) {
      t = val;
    }
  }

  if (t === undefined) {
    return map;
  }

  const [row, col] = pos;
  const newMap = new Map(map);
  newMap.set(`${row}#${col}`, t);
  return newMap;
}
