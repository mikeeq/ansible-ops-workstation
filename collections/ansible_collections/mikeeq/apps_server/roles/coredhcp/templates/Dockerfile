FROM golang:1.23 AS build_stage

LABEL BUILD="docker build -t coredhcp/coredhcp -f Dockerfile ."
LABEL RUN="docker run --rm -it coredhcp/coredhcp"

# install Go
WORKDIR /tmp
RUN git clone https://github.com/coredhcp/coredhcp

WORKDIR /tmp/coredhcp/cmds/coredhcp

# CGO_ENABLED=0 dynamic linking disable for scratch base
# build coredhcp
RUN set -exu ;\
    go get -v ./... ;\
    CGO_ENABLED=1 go build ;\
    # CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ;\
    cp coredhcp /bin

# https://github.com/coredns/coredns/blob/master/Dockerfile
# FROM scratch
FROM ubuntu
# FROM gcr.io/distroless/static-debian12:nonroot
# USER nonroot:nonroot
WORKDIR /

COPY --from=build_stage /bin/coredhcp .

EXPOSE 67/udp
EXPOSE 547/udp

ENTRYPOINT ["/coredhcp"]
