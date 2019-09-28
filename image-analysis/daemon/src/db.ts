import extra from "striomatrix-cv-extra";
import config from "../config";

export default new extra.db.default(`${config.FS_ROOT}/db.json`);
