# This Dockerfile is for Jetsons running JetPack 4.5 or 4.5.1 with CUDA 10.2

# Image must match your jetson's JetPack version, and the cuda-samples below
FROM nvcr.io/nvidia/l4t-base:r32.4.2

# Install the tools needed to build the `deviceQuery` binary
RUN apt-get update \
  && apt-get install -y --fix-missing --no-install-recommends \
  git \
  make \
  g++ \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the cuda-samples repo to get the `deviceQuery` source
WORKDIR /
RUN git clone https://github.com/NVIDIA/cuda-samples.git

# Get the cuda-samples for the CUDA version in the base image in the FROM above
WORKDIR /cuda-samples
RUN git checkout tags/v10.2

# Build the `deviceQuery` binary and install it as `/bin/dq`
WORKDIR /cuda-samples/Samples/deviceQuery
RUN make
RUN cp deviceQuery /bin/dq

# And finally run it then exit
CMD dq

