FROM nvcr.io/nvidia/l4t-base:r32.4.2
RUN apt-get update \
  && apt-get install -y --fix-missing --no-install-recommends \
  git \
  make \
  g++ \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /
RUN git clone https://github.com/NVIDIA/cuda-samples.git
WORKDIR /cuda-samples/Samples/deviceQuery
RUN make
RUN cp deviceQuery /bin/dq
CMD dq

