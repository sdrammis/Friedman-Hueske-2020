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

# Detailed System Explination 

## How the client and server applications share state information. 

The client and server communicate via the state of the file system. Samba server is ran on the server machine, allowing the client to connect and appear to mount the server's disk on the client machine. This allows the client and server to write and read “directly” to the server filesystem.

Each worker in the system has an associated file in the file system. For example, we have an algorithm that identifies striosomes. We call this worker the StrioAnalysis worker. In our filesystem tree, it has a folder named ”strio_analysis”. Workers that have no dependencies have a special parent folder called “pre_<worker_name>”, eg. pre_strio_analysis. These folders track the work that has been completed by the worker.

Executions get tracked by writing special <execution_name>-done.txt files in the worker folders. Work can be in two stages for a given worker, it can be in the “manual”' stage or in the “done” stage. The “manual” stage means the worker has seen the work and it has finished running the work, but it is waiting on a human to verify the results. Work gets moved to a “done” stage when the human finishes selected and verifying the results. We keep track of this by having two subdirectories in each worker folder: a /manual directory and a /done directory. When a worker finishes running the algorithm code on execution ex123 it writes a new file to /path/to/system-tree/<worker_name>/manual/ex123-done.txt.
Similarly when the human submits the manually checked results on the client, a file gets written to /path/to/system-tree/<worker_name>/done/ex123-done.txt. For any files that don't need to be persisted, there is a /tmp folder within the worker directory.

The special pre\_<worker_name> folder allows for manual work to be done before the top level worker is ran. For example, we need to cut out areas manually before we run striosome detection. So, when new execution ex456 is created, the file /path/to/system-tree/pre_strio_analysis/manual/ex456-done.txt is written, but nothing yet is written to the /done folder. But another worker, like cell body detection, will have the file /path/to/system-tree/pre_cell_body_detection/done/ex456-done.txt written immediately, meaning that the cell body worker can start work right away.

## Building the server to run many algorithms with dependency relationships. 

The server was programmed in Typescript and built with Node.js with calls to the Matlab computer vision algorithms using the child process Node library.

Work is structured as a directed acyclic graph (DAG). Workers must define if they are a top level node or which workers they are dependent on (also known as their parents). To find new work, a loop runs periodically checking for workers in the DAG who have work completed by all parents but not completed or queued by the worker. We can use this form of communication instead of http calls, queueing systems, or databases because we know the scale of our project. If we needed to scale the system to be very large, this approach would not be feasible. We would need to resolve dependencies and find new work much more quickly.

The landing page of the client is the Executions Page. Here users can see the list of all created executions and name and create new executions.

All other pages in the application are associated manual verification pages for the different workers. Each worker requires its own unique way to verify results and has specialized codes. For example, striosome analysis requires us to select the best looking output out of a list of 3 options ran with different parameters. Most evaluation pages allow for users to send results to be reran.

