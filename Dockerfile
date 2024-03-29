FROM golang:alpine as builder
WORKDIR /http-fs
ENV C_ENABLED=0
COPY *.go *.crt *.key ./
RUN go build

FROM alpine
RUN apk add --no-cache ca-certificates
RUN echo "<html><body><h1>XXXXXX</h1></body></html>" > /tmp/index.html
COPY --from=builder /http-fs/http-fs /http-fs/*.crt /http-fs/*.key /
EXPOSE 5000
CMD ["/http-fs", "-read-only", "-addr=0.0.0.0:5000", "-dir=/tmp"]
