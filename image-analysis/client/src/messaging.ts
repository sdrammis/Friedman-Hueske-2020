import extra from "striomatrix-cv-extra";
import config from "../config";

export default extra.messaging.connect(config.MESSAGING_HOST);
