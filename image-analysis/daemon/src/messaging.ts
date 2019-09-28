import extra from "striomatrix-cv-extra";
import config from "../config";

const PREFETCH = 2;
export default extra.messaging.connect(
  config.MESSAGING_HOST,
  PREFETCH
);
