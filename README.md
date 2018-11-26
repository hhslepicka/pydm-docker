
# PyDM Docker

A docker image with PyDM built-in.

## How to build the container

You can build the container, for example, like this:

```
$ docker build -t pydm .
```

## How to run the container

Since PyDM uses a graphical interface, you need to pass additional arguments in
order to properly forward X:

### On a Linux OS:

```
$ docker run -ti \
-u $(id -u) \
-e DISPLAY=unix$DISPLAY \
-v "/tmp/.X11-unix:/tmp/.X11-unix" \
-v "/etc/group:/etc/group:ro" \
-v "/etc/passwd:/etc/passwd:ro" \
-t pydm
```

### On a MAC OS:

First install XQuartz. Then run it from the command line using `open -a XQuartz`.
In the XQuartz preferences, go to the “Security” tab and make sure you’ve got
“Allow connections from network clients” ticked.

Now run:

```
$ IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
$ xhost + $IP
$ docker run -ti \
-e DISPLAY=$IP:0 \
-v <APP_DIR>:/python \
-t pydm
```
