const { app, BrowserWindow } = require("electron");
require("electron-reload")(`${__dirname}/dist/`);

app.on("ready", () => {
  const win = new BrowserWindow();
  win.loadFile("index.html");
});
