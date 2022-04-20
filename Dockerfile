# ===== Base image that enables developing pimote
FROM ubuntu:20.04 AS dev_environment

# --- System dependencies
RUN apt-get update && apt-get install -y curl git make parallel protobuf-compiler

# --- Golang setup
ARG GOLANG_TGZ_URL=https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
WORKDIR /opt
RUN curl -LO ${GOLANG_TGZ_URL} && \
    tar xfz *.tar.gz && \
    rm *.tar.gz
RUN mkdir -p /opt/gopath
ENV GOPATH=/opt/gopath
ENV PATH=${PATH}:/opt/gopath/bin:/opt/go/bin
# Needed to compile protos
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# --- Node.js setup
ARG NODEJS_TXZ_URL=https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.xz
WORKDIR /opt
RUN curl -LO ${NODEJS_TXZ_URL} && \
    tar xfJ *.tar.xz && \
    rm *.tar.xz && \
    mv node-* node
ENV PATH=${PATH}:/opt/node/bin
ENV NODE_PATH=/opt/node_modules


# --- Install/cache dependencies
WORKDIR /opt/dependencies
COPY server/Makefile server/go.mod server/go.sum server/
RUN make -C server deps && rm -rf server
COPY web/Makefile web/package.json web/package-lock.json web/
RUN make -C web deps && rm -rf web
# keep web around so we can copy node_modules later


# ===== Pre-built "distributable" target; dist_builder builds the stuff, the scratch image contains it
FROM dev_environment AS dist_builder

WORKDIR /pimote
COPY . .

# Reinstall npm deps from cache
RUN make -C web deps

# Run the make
ARG MAKE_ARGS
RUN make BINFILE=pimote ${MAKE_ARGS}
WORKDIR /pimote/dist
RUN cp -r ../server/bin/pimote . && \
    cp -r ../web/dist static_web
    
# --- The real dist image is bare and only contains the distributables
FROM scratch AS dist
WORKDIR /pimote
COPY --from=dist_builder /pimote/dist/ ./



# ===== "Default" run-once image based on the current code's dist build
FROM ubuntu:20.04 as runnable

# --- Storage volume is mounted at /storage
VOLUME [ "/storage" ]
ENV STORAGE_DIR=/storage

# --- Copy in the binaries
COPY --from=dist /pimote /pimote

# Static files are on port 8080 by default
ARG UI_PORT=8080
EXPOSE ${UI_PORT}
ENV UI_PORT=${UI_PORT}

# gRPC endpoints are on port 8081, and the UI needs to be told where they are
# NOTE: to serve remotely, UI_GRPC_ENPOINT *must* be overriden
EXPOSE 8081

ENV GRPC_PORT=8081
ENV UI_GRPC_ENDPOINT=http://localhost:8081

CMD /pimote/pimote /pimote/static_web



# ===== Image for creating a container on top of a mounted /pimote dir.
#       This dir must be the entire repo. The image runs `make watch`, 
#       and should really only be used for development purposes
FROM dev_environment AS runnable_watch

WORKDIR /pimote
CMD make watch



# === Default image, whcih is just the runnable from above (but it made sense to put it there rather than here)
FROM runnable AS default
RUN echo no-op