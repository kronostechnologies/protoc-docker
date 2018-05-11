FROM debian:jessie-slim

RUN apt-get update && apt-get install -y \
  build-essential autoconf git pkg-config \
  automake libtool curl make g++ unzip \
  && apt-get clean

# install protobuf first, then grpc
ENV GRPC_RELEASE_TAG v1.11.0
RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc && \
		cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make -j$(nproc) check && make install && make clean && ldconfig && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig

# Do not copy lib symbolic links
WORKDIR /build/
RUN find /usr/local/lib/ -type f -exec cp {} ./ \;


# Stage 2 - Make target container with binaries onlly
FROM debian:jessie-slim
MAINTAINER sysadmin@kronostechnologies.com

RUN apt-get update && apt-get install -y \
  sudo \
  && apt-get clean

COPY --from=0 /usr/local/bin/* /usr/local/bin/
COPY --from=0 /build/* /usr/local/lib/
RUN ldconfig

COPY protoc-wrapper.sh entrypoint.sh /usr/local/bin/

WORKDIR /code
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]