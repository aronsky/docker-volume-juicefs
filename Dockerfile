FROM golang:1.19 as builder

ARG GOPROXY

WORKDIR /docker-volume-juicefs
COPY . .
ENV GOPROXY=${GOPROXY:-"https://proxy.golang.org,direct"}
RUN apt-get update && apt-get install -y curl musl-tools tar gzip upx-ucl git \
    && CC=/usr/bin/musl-gcc go build -o bin/docker-volume-juicefs \
       --ldflags '-linkmode external -extldflags "-static"' .

WORKDIR /workspace
RUN git clone https://github.com/aronsky/juicefs.git -b add-internal-inodes-prefix-option \
    && cd juicefs && STATIC=1 make && upx juicefs

FROM python:2.7-alpine
RUN mkdir -p /run/docker/plugins /jfs/state /jfs/volumes
COPY --from=builder /docker-volume-juicefs/bin/docker-volume-juicefs /
COPY --from=builder /workspace/juicefs/juicefs /bin/
RUN /bin/juicefs version
CMD ["docker-volume-juicefs"]
