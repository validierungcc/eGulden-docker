FROM ubuntu:18.04 AS builder
COPY  --from=lncm/berkeleydb:v4.8.30.NC  /opt  /opt
ENV BDB_PREFIX="/opt/db4"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libboost-all-dev \
        libevent-dev \
        libssl-dev \
        ca-certificates \
        bsdmainutils

RUN addgroup --gid 1000 egulden && \
    adduser --disabled-password --gecos "" --home /egulden --ingroup egulden --uid 1000 egulden
USER egulden
RUN mkdir /egulden/.egulden

RUN git clone https://github.com/Electronic-Gulden-Foundation/egulden.git /egulden/eGulden
WORKDIR /egulden/eGulden
RUN git checkout tags/v1.5.0.0

RUN ./autogen.sh
RUN ./configure --without-gui BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include"
RUN make


FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libevent-dev \
        libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /egulden/eGulden/src/eguldend /usr/local/bin/eguldend
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN addgroup --gid 1000 egulden && \
    adduser --disabled-password --gecos "" --home /egulden --ingroup egulden --uid 1000 egulden

USER egulden
WORKDIR /egulden
RUN mkdir .egulden
VOLUME /egulden/.egulden

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 11015/tcp
EXPOSE 21015/tcp
