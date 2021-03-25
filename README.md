# dq

## PLEASE NOTE: The code in this repo is for the validation of the software configuration on NVIDIA Jetson machines only. If you wish to validate the software configuration on x86 machines with discrete NVIDIA GPU cards installed, it is much easier. Simply run `nvidia-smi`. To run that inside a container, run `docker run --rm nvidia/cuda nvidia-smi`. (You will first need to configure the NVIDIA docker runtime to be the default docker runtime).

## Also please note, there is no icecream here

This repo has nothing at all to do with the other DQ of icecream fame (https://www.dairyqueen.com/). :-)

## Now for the Jetson details

I use this repo to validate that I have a Jetson machine properly configured to enable GPU access inside a running Docker container. This code, despite being the most basic of examples direct from NVIDIA, is fragile. It must be carefully updated with each new JetPack release. Mostly for my own reference I am providing some utilities here to help with that.

You may notice the term "tegra" being used below. The jetson machines each contain specific NVIDIA Tegra-branded ARM64v8 system-on-a-chip modules with RAM and embedded NVIDIA GPUs.

#### Quick and easy

If you just want a quick and easy verification and you have installed the latest JetPack, then I have something here for you. I try to keep a ready-to-use image for the latest JetPack in my DockerHub account. To use it, simply run this:

```
docker run -it --rm ibmosquito/dq:32.4.2
```

If that works and shows matching **driver version** and **runtime version**, then you are good to go and can skip the rest of this!

#### Roll your own (e.g., when the above fails)

The Makefile is the best place to start. Run:

```
make
```

That will list the commands detailed below that provide info about your jetson's configuration:


#### make dq

The `dq` target will compile and run the NVIDIA CUDA sample program called `deviceQuery` **on the host**. Most importantly this  tool will show you the NVIDIA CUDA **driver version** and **runtime version**, and verify that they match. This is critical. If you don't get a matching result here nothing else will work so go back and fix that.


#### make nvruntime

The `nvruntime` target will help you to verify that you have the NVIDIA docker runtime installed and that it is configured to be the default container runtime. You should see this output:

```
 Runtimes: nvidia runc
 Default Runtime: nvidia
```

If not, you need to install the NVIDIA container runtime and configure it to be the default. On a jetson it should already be installed but it is not the default. Edit `/etc/docker/daemon.json` so it contains exactly the following, then reboot and run the above command again to verify you fixed it. The file should contain exactly this:

```
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

#### make tegrarelease

This will show you the installed "tegra" **hardware** release number. You should see output similar to the following:

```
# R32 (release), REVISION: 5.1, GCID: 26202423, BOARD: t210ref, EABI: aarch64, DATE: Fri Feb 19 16:45:52 UTC 2021
```

#### make l4tversion

This comman will show the installed "Linux for Tegra" (L4T) **software** version. You should see output similar to the following:

```
nvidia-l4t-core	32.5.1-20210219084526
```

## What to do when this breaks


Let me just walk you throguh my process for fixing the Dockerfile for this container.  Currently I am using the latest JetPack 4.5.1. You can see this in the output from the above commands. Also, the `dq` output on my machine includes this line:

```
CUDA Driver Version / Runtime Version          10.2 / 10.2
```

Ideally all the above info would Lead me to use this base image: `nvcr.io/nvidia/l4t-base:r32.5.1`, but no such image exists! I then tried: `nvcr.io/nvidia/l4t-base:r32.5.0`. That one exists, but I am unable to download and build samples in that image (it appears the certificate store is not properly configured and I don't want to bother dealing with that). Instead I fell back on `nvcr.io/nvidia/l4t-base:r32.4.2` because I happen to know that this base image contains CUDA v10.2 (the same version in JetPack 4.5.1). It works. So I stopped fiddling with it.

I find that after each JetPack release I usually need to tweak the base image (the one in the `FROM` statement at the top of the Dockerfile. If the CUDA version has changed then I also need to change to the correct `tag` in the `cuda-samples` repo a little later in the Dockerfile, on this line:

```
RUN git checkout tags/v10.2
```

Edit the `v10.2` string to reflect the version number that you get from the `make dq` output above. You can check the versions that are available in the [cuda-samples github repo](https://github.com/NVIDIA/cuda-samples).

