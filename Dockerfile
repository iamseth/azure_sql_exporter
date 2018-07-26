FROM golang:1.10 as build-env
ADD . /go/src/github.com/iamseth/azure_sql_exporter
WORKDIR /go/src/github.com/iamseth/azure_sql_exporter
RUN make
RUN mv dist/azure_sql_exporter* dist/azure_sql_exporter

FROM debian:latest
WORKDIR /app
COPY --from=build-env /go/src/github.com/iamseth/azure_sql_exporter/dist/azure_sql_exporter /app/
VOLUME [ "/config" ]
ENTRYPOINT /app/azure_sql_exporter -config.file=/config/config.yaml
