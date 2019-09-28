const fs = require("fs");

const filename = process.argv[2];
const execname = process.argv[3];
const tmpdir = process.argv[4];

const data = JSON.parse(fs.readFileSync(filename).toString());

for (const region of data.regionMaskMap) {
  const rc = region[0].split("#");
  const { clickX, clickY, clickDrag } = region[1];

  const { createCanvas } = require("canvas");
  const canvas = createCanvas(500, 500);
  const context = canvas.getContext("2d");
  context.lineCap = "round";
  context.lineJoin = "round";
  context.strokeStyle = "blue";
  context.lineWidth = 20;
  for (let i = 0; i < clickX.length; ++i) {
    context.beginPath();
    if (clickDrag[i] && i) {
      context.moveTo(clickX[i - 1], clickY[i - 1]);
    } else {
      context.moveTo(clickX[i] - 1, clickY[i]);
    }
    context.lineTo(clickX[i], clickY[i]);
    context.stroke();
  }
  context.closePath();
  const mskName =
    tmpdir + "/" + execname + "-" + rc[0] + "-" + rc[1] + "-msk.png";
  const out = fs.createWriteStream(mskName);
  const stream = canvas.createPNGStream();
  stream.pipe(out);
  out.on("finish", () => console.log("The PNG file was created."));
}
