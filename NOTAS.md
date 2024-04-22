 

 # PREPARACION CLUSTER

 ## PUBLICO
  - make create-cluster-simple 
  -  gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a --project sparta-proyect-host 
 

 ## PRIVADO
  - make create-cluster-simple-privated  
  - gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a --project sparta-proyect-host 
  - gcloud container clusters update autopilot-cluster-app --enable-master-authorized-networks  --master-authorized-networks 190.215.171.124/32
  - gcloud container clusters get-credentials autopilot-cluster-app --project=sparta-proyect-host --zone=us-central1-a   --internal-ip


## ESPACIOS  DE NOMBRES
 - kubectl apply -f .\minifiest\cluster\00-namespace.yaml


# COLLECTOR EN MODO OPERADOR PARA LA AUTO-ISTRUMENTACION
 - kubectl apply  -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
 - kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

##  OPCION LATAM
  - kubectl apply -f .\minifiest\otel\1.2otel-config-auto.yaml

##  OPCION LAB
  - kubectl apply -f .\minifiest\otel\1.1otel-config-auto.yaml


# MODOS INSTALACION MICROSERVICIOS  AUTO-INSTRUMENACION 
  - Opcion 1 : kubectl apply -f .\minifiest\deployment-apps-auto.yml 
  - Opcion 2 : kubectl apply -f .\minifiest\replicaset-apps-auto.yml




# COLLECTOR SIMPLE + APPS CON INSTRUMENTACION MANUAL
 - kubectl apply -f .\minifiest\otel-config-simple.yaml
 - kubectl apply -f .\minifiest\deployment-apps.yml


# ADICIONAL : PROBAR ISTIO
 
Instalar istio y demo
  - $ curl -L https://istio.io/downloadIstio | sh -
  - export PATH=$PWD/bin:$PATH
  - istioctl install --set profile=demo -y

### Instalar Colector
 PASOS MAS ARRIBA

### Intervenir pod java con auto instrumentacion
kubectl apply -f .\istio-base\bookinfo.yaml


### Instalar agente grafana
 PASOS MAS ARRIBA




````
kubectl exec --stdin --tty hello-observability-7dxl7 --namespace applications -c app -- /bin/bash

kubectl exec --stdin --tty grafana-agent-0 --namespace monitoring -c grafana-agent -- /bin/bash

```` 