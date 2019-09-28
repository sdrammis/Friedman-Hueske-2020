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
Add a `config.ts` at `daemon/` (ask Sabrina for config example)

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
Add a `config.ts` at `client/` (ask Sabrina for config example)


## Run Client

In one terminal (or split) run

```
$ npm run dev-pack
```

In another terminal (or split) run

```
$ npm run start
```
