
# PyDM Docker

A docker image with PyDM built-in.

## How to run the container

Since PyDM uses a graphical interface, you need to pass additional arguments in
order to properly forward X:

#### Linux:
```
$ docker pull pydm/pydm:latest
$ docker run --rm \
-u $(id -u):$(id -g) \
-e DISPLAY=unix$DISPLAY \
-v "/tmp/.X11-unix:/tmp/.X11-unix" \
-v "/etc/group:/etc/group:ro" \
-v "/etc/passwd:/etc/passwd:ro" \
-t pydm:pydm
```

#### MacOS:

First install XQuartz. Then run it from the command line using `open -a XQuartz`.
In the XQuartz preferences, go to the “Security” tab and make sure you’ve got
“Allow connections from network clients” ticked. Restart XQuartz.

```
$ docker pull pydm/pydm:latest
$ IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
$ xhost + $IP
$ docker run --rm -ti -e DISPLAY=$IP:0 pydm/pydm
```

#### Windows:

First install XQuartz. In the XQuartz preferences, go to the “Security” tab and make sure you’ve got
“Allow connections from network clients” ticked.

```
$ docker pull pydm/pydm:latest
$ docker run --rm -ti -e DISPLAY=host.docker.internal:0.0 pydm:pydm
```

## Sharing a folder with the container

In order to share a folder with your container you need to add an extra parameter
to the way it is launched.

The extra parameter is in the following format: `-v <local path>:<container path>`.
E.g.: To share a folder on linux `/tmp/screens` with the container and have it at `/pydm/workspace`
you need to specify `-v /tmp/screens:/pydm/workspace`.

```
$ docker run --rm -ti -e DISPLAY=$IP:0 -v /tmp/screens:/pydm/workspace pydm:pydm
```

One recommendation is to use `/pydm/workspace` when sharing folders with this container.
The container will use this folder as initial work directory.


For more information on shared folders please read the 
[Docker documentation for volumes](https://docs.docker.com/storage/volumes/#start-a-container-with-a-volume).

## Changing default work directory

The default work directory is `/pydm/workspace`. In order to change that you
need to specify an extra parameter at the launching script: `--workdif <container path>`

## Launching PyDM and QtDesigner

Instead of getting access to the shell at the container you can specify a command
to be executed such as `pydm` or `designer`.

E.g: Opening PyDM:

```
$ docker run --rm -ti -e DISPLAY=$IP:0 pydm:pydm pydm
```

The `t` option will allocate a pseudo-TTY, the `i` is for interactive and will
keep STDIN open even if not attached.

In order to run detached remove `-ti` and use `-d` which will run the container
in background and print the container ID.

## Running with an user other than root
By default the container will run as root, which may cause some issues when
a folder is shared with the container and files are modified.
One suggestion valid for Linux and macOS to specify the UID and 
GID for the container is to use the `-u` parameter:
`-u $(id -u):$(id -g)`.

At a Linux system it is possible to share as ReadOnly the group and passwd files
so the container will present the correct values for the username and group. For
macOS I couldn't find a way to accomplish that yet.

#### Linux sharing group and passwd
```
$ docker pull pydm/pydm:latest
$ docker run \
--rm \
-u $(id -u):$(id -g) \
-e DISPLAY=unix$DISPLAY \
-v "/tmp/.X11-unix:/tmp/.X11-unix" \
-v "/etc/group:/etc/group:ro" \
-v "/etc/passwd:/etc/passwd:ro" \
-t pydm:pydm
```

## Useful aliases

Here are some useful aliases for Linux and macOS to launch QtDesigner and PyDM
at the docker container sharing the current folder.

#### Linux
```
alias pydm='docker run --rm -d -u $(id -u):$(id -g) -e DISPLAY=unix$DISPLAY  -v ${PWD}:/pydm/workspace -v "/tmp/.X11-unix:/tmp/.X11-unix" -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" pydm:pydm pydm'
alias designer='docker run --rm -d -u $(id -u):$(id -g) -e DISPLAY=unix$DISPLAY  -v ${PWD}:/pydm/workspace -v "/tmp/.X11-unix:/tmp/.X11-unix" -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" pydm:pydm designer'
alias pydmbash='docker run --rm -it -u $(id -u):$(id -g) -e DISPLAY=unix$DISPLAY  -v ${PWD}:/pydm/workspace -v "/tmp/.X11-unix:/tmp/.X11-unix" -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" pydm:pydm'
```

#### macOS
Remember to also define `IP` and register it with `xhost + ${IP}` as instructed
above.
```
alias pydm='docker run -d -u $(id -u):$(id -g) -e DISPLAY=${IP}:0 -v ${PWD}:/pydm/workspace pydm/pydm pydm'
alias designer='docker run --rm -d -u $(id -u):$(id -g) -e DISPLAY=${IP}:0 -v ${PWD}:/pydm/workspace pydm/pydm designer'
alias pydmbash='docker run --rm -it -u $(id -u):$(id -g) -e DISPLAY=${IP}:0 -v ${PWD}:/pydm/workspace pydm/pydm'
```

## How to build the container

You can build the container, for example, like this:

```
$ git clone https://github.com/hhslepicka/pydm-docker.git
$ cd pydm-docker.git
$ docker build -t pydm/pydm .
```
