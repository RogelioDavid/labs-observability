FROM grafana/alloy:v1.6.1
EXPOSE 12345

COPY config-metrics-logs.alloy /etc/alloy/config.alloy
 
 
CMD ["run" "/etc/alloy/config.alloy" "--storage.path=/var/lib/alloy/data"]