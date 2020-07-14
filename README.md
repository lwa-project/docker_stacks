# LWA Docker Images

[Docker images](https://hub.docker.com/u/lwaproject) for the [LWA Software Library (LSL)](https://github.com/lwa-project/lsl) and the various user-facing tools for the Long Wavelenth Array.

## Images
The available images are:
- base:  LSL installed on Ubuntu 18.04 in a Python3.6 virtualenv.
- session_schedules:  *base* + the [LWA scheduling tools](https://github.com/lwa-project/session_schedules), plus firefox to submit schedules.
- raw_data: *session_schedules* + the [LWA commissioning tools](https://github.com/lwa-project/commissioning) for working with raw LWA data.
- pulsar:  *raw_data* + the [LWA pulsar tools](https://github.com/lwa-project/pulsar) for working pulsar data.  This also includes TEMPO, PRESTO, psrcat, psrchive, and dspsr.
- baseline:  *session_schedules* + AIPS and difmap for working with LWA Single Baseline Interferometer data.
- jupyter:  *base* + a Jupyter notebook server based off [this image](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook).

## Usage
To start an image without a graphical interface:
```
docker pull lwaproject/lsl:{image_name}
docker run -it lwaproject/lsl:{image_name}
```

For using a graphical interface there are two options:  X11 forwarding and [xpra](https://xpra.org/).  X11 forwarding works well locally on Linux and OSX machines but requires some perseverance to get working.  xpra is easiser to setup and can be used with:
```
docker pull lwaproject/lsl:{image_name}
docker run -it -p 10000:10000 lwaproject/lsl:{image_name}
```
Once Docker is running, from inside the container start the xpra server:
```
export DISPLAY=:100
xpra start --bind-tcp=0.0.0.0:10000 $DISPLAY
```
After xpra starts and moves into the background you need to start the xpra client on your Docker host machine.  To do this run:
```
/path/to/your/xpra attach tcp://localhost:10000/
```
At this point any graphical programs started in the container should appear on your screen.  Once you are finished with the container, simply exit and the xpra client should exit as well.

## Resources
- [Long Wavelength Array website](http://lwa.unm.edu)
- [LWA data reduction tutorial](https://lda10g.alliance.unm.edu/tutorial/)
- [Images on Docker Hub](https://hub.docker.com/u/lwaproject)
