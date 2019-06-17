# Azure SQL Exporter

[![Build Status](https://travis-ci.org/iamseth/azure_sql_exporter.svg)](https://travis-ci.org/iamseth/azure_sql_exporter)
[![GoDoc](https://godoc.org/github.com/iamseth/azure_sql_exporter?status.svg)](http://godoc.org/github.com/iamseth/azure_sql_exporter)
[![Report card](https://goreportcard.com/badge/github.com/iamseth/azure_sql_exporter)](https://goreportcard.com/badge/github.com/iamseth/azure_sql_exporter)

[Prometheus](https://prometheus.io/) exporter for Azure SQL metrics. See [this post](https://azure.microsoft.com/en-us/blog/azure-sql-database-introduces-new-near-real-time-performance-metrics/) for details.

Metrics are collected from each database using SQL so this could easily be modified or extended to support SQL Server though it may have better metrics exporting natively than through SQL.

Databases are only queries when fetching /metrics from the exporter so that you may control the interval from your scrape_config section in Prometheus.

## Install

```bash
go get -u github.com/iamseth/azure_sql_exporter
```

## Usage
```bash
Usage of azure_sql_exporter:
  -config.file string
    	Specify the config file with the database credentials. (default "./config.yaml")
  -log.level value
    	Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal, panic]. (default info)
  -web.listen-address string
    	Address to listen on for web interface and telemetry. (default ":9139")
  -web.telemetry-path string
    	Path under which to expose metrics. (default "/metrics")
```

## Configuration

This exporter requires a configuration file. By default, it will look for the config.yaml file in the CWD and can be specified with the -config.file parameter.

The file is in YAML format and contains the information for connecting to the databases you want to export. This file will contain sensitive information so make sure your configuration management locks down access to this file (chmod [46]00) and it is encouraged to create an SQL user with the least amount of privilege.

```yaml
databases:
  - name: Sales
    user: prometheus
    port: 1433
    password: str0ngP@sswordG0esHere
    server: salesdb.database.windows.net

  - name: Inventory
    user: prometheus
    port: 1433
    password: str0ngP@sswordG0esHere
    server: inventorydb.database.windows.net
```


## Binary releases

Pre-compiled versions may be found in the [release section](https://github.com/iamseth/azure_sql_exporter/releases).

## Docker

A Dockerfile is provided, or images are available on [Docker Hub](https://hub.docker.com/r/benclapp/azure_sql_exporter/). For example:

```bash
docker run -d -p 9139:9139 -v ./config.yaml:/config/config.yaml benclapp/azure_sql_exporter:latest -config.file /config/config.yaml
```