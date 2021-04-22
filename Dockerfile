FROM rust as builder
RUN apt update && apt install -y \
    build-essential \
    bzr \
    clang \
    curl \
    gcc \
    git \
    hwloc \
    jq \
    libhwloc-dev \
    mesa-opencl-icd \
    ocl-icd-opencl-dev \
    pkg-config \
    wget \
    && apt upgrade -y
RUN wget -c https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
ENV PATH /usr/local/go/bin:$PATH
RUN git clone https://github.com/filecoin-project/lotus.git
WORKDIR lotus
ENV CGO_CFLAGS_ALLOW "-D__BLST_PORTABLE__"
ENV CGO_CFLAGS "-D__BLST_PORTABLE__"
RUN make clean all

FROM debian
RUN apt update && apt install -y \
    ca-certificates \
    libhwloc5 \
    mesa-opencl-icd \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /lotus/lotus* /usr/local/bin

