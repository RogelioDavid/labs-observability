docker build -f Dockerfile -t rmendoza/collector-alloy:v1 .


docker run  -v config-metrics-logs.alloy:/etc/alloy/config.alloy -p 12345:12345 grafana/alloy:latest run --server.http.listen-addr=0.0.0.0:12345 --storage.path=/var/lib/alloy/data     /etc/alloy/config.alloy


docker run   -p 12345:12345 -t rmendoza/collector-alloy:v1 run --server.http.listen-addr=0.0.0.0:12345 --storage.path=/var/lib/alloy/data  /etc/alloy/config.alloy



gcloud run services replace deploy-services.yml --platform managed