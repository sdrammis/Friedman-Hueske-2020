const fs = require("fs");

// Get a list of mouse IDs in the pipeline

const DB_PATH = "/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/db.json";

const db = JSON.parse(fs.readFileSync(DB_PATH));
const exids = db.executions.map(ex => ex.exid);
const mouseIDs = exids
  .map(exid => exid.match(/_[0-9]+_(r|s)/g))
  .filter(s => s !== null)
  .map(s => s[0].split("_")[1]);
const unqMouseIDs = [...new Set(mouseIDs)];

console.log(unqMouseIDs);
