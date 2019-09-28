import chalk from "chalk";

enum Level {
  DEBUG,
  INFO,
  WARN,
  ERROR
}

const colorMap = {
  [Level.DEBUG]: "green",
  [Level.INFO]: "white",
  [Level.WARN]: "yellow",
  [Level.ERROR]: "red"
};

const log = (level: Level, msg: string, service = "") => {
  // TODO fix color logging
  const color = (chalk as any)[colorMap[level]];
  // TODO Prefix with service name and error level
  console.log(color(`${Date.now()} ${service} ${msg}`));
};

export default {
  debug(msg: string, service?: string) {
    log(Level.DEBUG, msg, service);
  },
  info(msg: string, service?: string) {
    log(Level.INFO, msg, service);
  },
  warn(msg: string, service?: string) {
    log(Level.WARN, msg, service);
  },
  error(msg: string, service?: string) {
    log(Level.ERROR, msg, service);
  }
};
