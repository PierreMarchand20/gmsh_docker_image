FROM ubuntu:20.04

# opencascade
RUN  ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake git \
    g++ gcc\
    gfortran \
    tcl-dev \
    tk-dev \
    libgl1-mesa-dev \
    libxi-dev \
    libxmu-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth 1 --branch V7_5_0 https://github.com/Open-Cascade-SAS/OCCT.git opencascade \
    && mkdir opencascade/build \
    && cd opencascade/build \
    && cmake .. \
    && make -j "$(nproc)"\
    && make install && cd ../.. && rm -rf opencascade \
    && DEBIAN_FRONTEND="interactive"


# GMSH
RUN apt-get update && apt-get install -y --no-install-recommends \
    libblas-dev \
    liblapack-dev \
    mesa-common-dev \
    libgl1-mesa-glx \
    libglu1-mesa-dev \
    freeglut3-dev \
    mesa-common-dev \
    mesa-utils \ 
    libfltk1.3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://gitlab.onelab.info/gmsh/gmsh.git \
    && cd gmsh \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install && cd ../../ && rm -rf gmsh

VOLUME /data

ENTRYPOINT ["gmsh"]
