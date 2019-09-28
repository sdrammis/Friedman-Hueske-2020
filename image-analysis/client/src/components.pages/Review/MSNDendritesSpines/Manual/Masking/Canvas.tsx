import * as React from "react";
import { IMG_SIZE } from "../../consts";

interface P {
  imsrc: string;
  init: { clickX: number[]; clickY: number[]; clickDrag: boolean[] };
  onmouseup: () => void;
}

class Canvas extends React.Component<P> {
  canvas: HTMLCanvasElement;
  ctx: CanvasRenderingContext2D;
  img: HTMLImageElement;
  clickX: number[];
  clickY: number[];
  clickDrag: boolean[];
  paint = false;

  constructor(props: P) {
    super(props);

    const img = new Image();
    img.src = this.props.imsrc;
    img.width = IMG_SIZE;
    img.height = IMG_SIZE;
    this.img = img;

    if (props.init === undefined) {
      this.clickX = [];
      this.clickY = [];
      this.clickDrag = [];
    } else {
      this.clickX = props.init.clickX;
      this.clickY = props.init.clickY;
      this.clickDrag = props.init.clickDrag;
    }
  }

  componentDidMount() {
    const canvas = document.getElementById("canvas") as HTMLCanvasElement;
    let ctx = canvas.getContext("2d");
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    ctx.strokeStyle = "blue";
    ctx.lineWidth = 20;

    this.canvas = canvas;
    this.ctx = ctx;

    this.redraw();
    this.createUserEvents();
  }

  public getCanvasData() {
    const { clickX, clickY, clickDrag } = this;
    const { width, height } = this.canvas;
    const imdata = Array.from(this.ctx.getImageData(0, 0, width, height).data);

    // NOTE: The mask creation expects the drawing color to be blue
    const mask = [];
    for (let i = 0; i < imdata.length - 3; i += 4) {
      const r = imdata[i];
      const g = imdata[i + 1];
      const b = imdata[i + 2];
      mask.push([r, g, b] === [0, 0, 255] ? 1 : 0);
    }
    return { clickX, clickY, clickDrag, mask };
  }

  public clearCanvas() {
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.clickX = [];
    this.clickY = [];
    this.clickDrag = [];
    this.redraw();
  }

  private createUserEvents() {
    let canvas = this.canvas;

    canvas.addEventListener("mousedown", this.pressEventHandler);
    canvas.addEventListener("mousemove", this.dragEventHandler);
    canvas.addEventListener("mouseup", this.releaseEventHandler);
    canvas.addEventListener("mouseout", this.cancelEventHandler);

    canvas.addEventListener("touchstart", this.pressEventHandler);
    canvas.addEventListener("touchmove", this.dragEventHandler);
    canvas.addEventListener("touchend", this.releaseEventHandler);
    canvas.addEventListener("touchcancel", this.cancelEventHandler);
  }

  private redraw() {
    const clickX = this.clickX;
    const context = this.ctx;
    const clickDrag = this.clickDrag;
    const clickY = this.clickY;

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
  }

  private addClick(x: number, y: number, dragging: boolean) {
    this.clickX.push(x);
    this.clickY.push(y);
    this.clickDrag.push(dragging);
  }

  private releaseEventHandler = () => {
    this.paint = false;
    this.redraw();
    this.props.onmouseup();
  };

  private cancelEventHandler = () => {
    this.paint = false;
  };

  private pressEventHandler = (e: MouseEvent | TouchEvent) => {
    let mouseX = (e as TouchEvent).changedTouches
      ? (e as TouchEvent).changedTouches[0].pageX
      : (e as MouseEvent).pageX;
    let mouseY = (e as TouchEvent).changedTouches
      ? (e as TouchEvent).changedTouches[0].pageY
      : (e as MouseEvent).pageY;
    mouseX -= this.canvas.offsetLeft;
    mouseY -= this.canvas.offsetTop;

    this.paint = true;
    this.addClick(mouseX, mouseY, false);
    this.redraw();
  };

  private dragEventHandler = (e: MouseEvent | TouchEvent) => {
    let mouseX = (e as TouchEvent).changedTouches
      ? (e as TouchEvent).changedTouches[0].pageX
      : (e as MouseEvent).pageX;
    let mouseY = (e as TouchEvent).changedTouches
      ? (e as TouchEvent).changedTouches[0].pageY
      : (e as MouseEvent).pageY;
    mouseX -= this.canvas.offsetLeft;
    mouseY -= this.canvas.offsetTop;

    if (this.paint) {
      this.addClick(mouseX, mouseY, true);
      this.redraw();
    }

    e.preventDefault();
  };

  render() {
    return (
      <div>
        <img
          style={{ position: "absolute" }}
          id="img"
          src={this.props.imsrc}
          width={IMG_SIZE}
          height={IMG_SIZE}
        />
        <canvas
          style={{
            position: "absolute",
            borderWidth: "2px",
            borderStyle: "solid",
            borderColor: "blue"
          }}
          id="canvas"
          width={IMG_SIZE}
          height={IMG_SIZE}
        />
      </div>
    );
  }
}
export default Canvas;
