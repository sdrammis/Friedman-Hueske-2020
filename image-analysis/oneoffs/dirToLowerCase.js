const fs = require("fs");

function dirToLowerCase(dir) {
  fs.readdir(dir, (err, items) => {
    if (err) {
      console.log(err);
      return;
    }

    items.forEach(item => {
      try {
        console.log(item);
        const path = dir + "/" + item;
        const stats = fs.lstatSync(path);
        if (stats.isDirectory()) {
          return dirToLowerCase(path);
        } else if (stats.isFile()) {
          fs.renameSync(path, dir + "/" + item.toLowerCase());
          return;
        }
      } catch (e) {
        console.log(e);
      }
    });
  });
}

dirToLowerCase("/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES");
