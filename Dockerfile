FROM alpine:3.17.3 as builder
RUN apk add --no-cache git make g++ boost-dev openssl-dev miniupnpc-dev db-dev zlib-dev bash libevent-dev autoconf automake libtool db

RUN addgroup --gid 1000 egulden
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /egulden \
    --ingroup egulden \
    --uid 1000 \
    egulden

USER egulden
RUN mkdir /egulden/.egulden
VOLUME /egulden/.egulden

RUN git clone https://github.com/Electronic-Gulden-Foundation/egulden.git /egulden/eGulden
WORKDIR /egulden/eGulden
RUN git checkout tags/v1.5.0.0
ENV CXXFLAGS="-std=c++11"

RUN ./autogen.sh
RUN ./configure --without-gui --with-incompatible-bdb
RUN make

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 11015/tcp
EXPOSE 21015/tcp
