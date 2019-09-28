export type ValMap = Map<string, number | null>;

export interface Mask {
  clickX: number[];
  clickY: number[];
  clickDrag: boolean[];
  mask: number[];
}

export type MaskMap = Map<string, Mask>;

export type Pos = [number, number];

export interface Metadata {
  dendThreshs: number[];
  spinesThreshs: number[];
}
