import * as React from "react";
// @ts-ignore
import ReactImageMagnify from "react-image-magnify";

interface P {
  src: string;
  width: number;
  height: number;
  zoomfact: number;
  zoomID: string;
}

class ImageZoom extends React.Component<P> {
  constructor(props: P) {
    super(props);
  }

  render() {
    const { src, width, height, zoomfact, zoomID } = this.props;
    return (
      <ReactImageMagnify
        smallImage={{ src, width, height }}
        largeImage={{ src, width: width * zoomfact, height: height * zoomfact }}
        enlargedImagePortalId={zoomID}
      />
    );
  }
}

export default ImageZoom;
