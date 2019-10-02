## Install Node

https://nodejs.org/en/

## Setup Extra

```
$ cd extra/
$ npm install
$ npm build
$ npm link
```

## Setup Daemon

```
$ cd daemon/
$ npm install
$ npm link striomatrix-cv-extra
```
Add a `config.ts` at `daemon/` (see below for config example)

## Run Daemon

```
$ npm run dev
```

## Setup Client

```
$ cd client/
$ npm install
$ npm link striomatrix-cv-extra
```
Add a `config.ts` at `client/` (see below for config example)


## Run Client

In one terminal (or split) run

```
$ npm run dev-pack
```

In another terminal (or split) run

```
$ npm run start
```

## Example config.ts (for both client and server)
```
export default {
    FS_ROOT: "/path/to/system-tree",
    IMAGES_FOLDER: "/path/to/histology/images",
    MATLAB_PATH: "/usr/local/MATLAB/version/bin/matlab",
    WORKERS_PATH: "/path/to/image-analysis/workers",
    MESSAGING_HOST: ""
}
```

## Example of file system structure:
```
system-tree
|- db.json
|- pre_strio_analysis
|  |- done
|  |- manual
|     |- bar-done.txt
|     |- baz-done.txt
|     |- foo-done.txt
|- strio_analysis
|  |- done
|  |  |- bar-done.txt
|  |- manual
|  |  |- bar-done.txt
|  |  |- foo-done.txt
```

