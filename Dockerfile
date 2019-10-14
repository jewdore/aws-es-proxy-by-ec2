FROM golang:1.12-alpine as builder

WORKDIR /app

ENV GO111MODULE=on GOARCH=amd64 GOOS=linux CGO_ENABLED=0

# for vgo download go repo
RUN apk add git \
    && rm -rf /var/cache/apk/*

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY aws-es-proxy.go .
RUN go build -o /tmp/app .

FROM alpine:3.10

LABEL name="aws-es-proxy-by-ec2" \
      version="latest"
COPY --from=builder /tmp/app /app
RUN apk --no-cache add ca-certificates
RUN apk add curl bash \
    && rm -rf /var/cache/apk/*

EXPOSE 9200
ENTRYPOINT ["/app"]
CMD ["/app", "-h"]