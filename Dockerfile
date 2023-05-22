ARG BASEIMAGE=busybox

FROM golang:1.20 as builder

ENV CGO_ENABLED 0

COPY . /src
WORKDIR /src
RUN go build --installsuffix cgo -ldflags="-s -w -extldflags '-static'" -a -o /configmap-reload configmap-reload.go

FROM ${BASEIMAGE}

LABEL org.opencontainers.image.source="https://github.com/rancher-sandbox/configmap-reload"

USER 65534

COPY --from=builder /configmap-reload /configmap-reload

ENTRYPOINT ["/configmap-reload"]
