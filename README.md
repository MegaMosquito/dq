# dq

Builds and runs the NVIDIA device query tool (for NVIDIA Jetson devices).

I have this pre-built for the current l4t-base version, `r32.4.2`, in my DockerHub account at: `ibmosquito/dq:32.4.2`, so the easiest way to use this is:

```
docker run -it ibmosquito/dq:32.4.2
```

Otherwise you can clone this repo, and just run `make`. That will build a local copy of the container and run it.

This repo has nothing at all to do with the other DQ (https://www.dairyqueen.com/). :-)

