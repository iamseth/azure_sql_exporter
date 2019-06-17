FROM alpine:latest as certificates
RUN apk update && apk add --no-cache ca-certificates && update-ca-certificates


FROM golang:1.12 as builder
ADD . /go/src/github.com/iamseth/azure_sql_exporter
WORKDIR /go/src/github.com/iamseth/azure_sql_exporter
RUN CGO_ENABLED=0 go build -ldflags "-X main.Version=$(cat VERSION)"

FROM scratch

# Copy certs from alpine as they don't exist from scratch
COPY --from=certificates /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/github.com/iamseth/azure_sql_exporter/azure_sql_exporter /app/

WORKDIR /app
ENTRYPOINT ["/app/azure_sql_exporter"]
