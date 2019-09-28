import { ValMap, Pos } from "./types";

export function getImgSrc(exid: string, dir: string, pos: Pos, map: ValMap) {
  const [row, col] = pos;
  const thresh = map.get(`${row}#${col}`);

  const dirExid = `${dir}/manual/${exid}/`;
  const imgog = `${dirExid}/thresh_1/og-${exid}-${row}-${col}.png`;
  const imgsrc =
    thresh === undefined || thresh === null
      ? imgog
      : `${dirExid}/thresh_${thresh}/${exid}-${row}-${col}.png`;

  return { imgsrc, imgog };
}

export function updatePos(
  numrows: number,
  numcols: number,
  pos: Pos,
  keycode: 78 | 80
) {
  const dir = keycode === 78 ? "next" : "prev";
  const [row, col] = pos;
  let newPos: [number, number] = pos;
  if (dir === "next") {
    if (col === numrows) {
      newPos = row === numcols ? (newPos = [1, 1]) : (newPos = [row + 1, 1]);
    } else {
      newPos = [row, col + 1];
    }
  } else {
    if (col === 1) {
      newPos =
        row === 1
          ? (newPos = [numrows, numcols])
          : (newPos = [row - 1, numcols]);
    } else {
      newPos = [row, col - 1];
    }
  }
  return newPos;
}
