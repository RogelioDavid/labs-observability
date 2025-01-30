

# PREPARACION DE CLUSTERS


````
  APLICACIONES

  - make create-cluster-simple 
  -  gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a  --project sparta-proyect-host
  - kubectl apply -f .\clustering\multiple\manifiest\00-namespace-apps.yaml

 OBSERVABILIDAD

  - make create-cluster-simple-obs 
  -  gcloud container clusters get-credentials autopilot-cluster-obs --zone=us-central1-a  --project sparta-proyect-host
  - kubectl apply -f .\clustering\multiple\manifiest\00-namespace-obs.yaml
```` 
 


# PREPARACION DE PLATAFORMA OBSERVABLIDAD


##  instalacion Grafana Alloy

````
   -  kubectl apply -f .\clustering\multiple\grafana-alloy\alloy\
   -  
````

## sacar la ip que declara el load balacer de alloy de trazas

# PREPARACION DE PLATAFORMA APLICACIONES


##  instalar los Custom Resource para soportar Open Telemetry Collector sidecar como auto instrumentacion

````
  - kubectl apply  -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
  - kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
````

# MANIFIESTOS PARA LA UTILIZACION DE OPEN-TELEMETRY

## 5.1- instalar la opcion de auto-instrumentacion para enviarlo al alloy de trazas hacia grafana-alloy (poner la ip en el lb)

````
  - kubectl apply -f .\clustering\multiple\grafana-alloy\otel\otel-config-auto-Instrumentation.yaml
````

## 5.2- instalar la opcion de collector en modo Sidecar de otel y utilizando la instrumentacion manual hacia al collector grafana-alloy de trazas (poner la ip en el lb)

````
  - kubectl apply -f .\clustering\multiple\grafana-alloy\otel\otel-config-sidecar.yaml
````

## 5.3- instalar la opcion de collector en modo Sidecar y auto-instrumentacion , solo para inyectar el agente pero en nivel de sidecar de enviar al collector alloy de trazas (poner la ip en el lb) 

````
  - kubectl apply -f .\clustering\multiple\grafana-alloy\otel\otel-config-sidecard-with-auto-instrumentacion.yml
````

# MANIFIESTOS PARA INSTANAR LA APLICACION

## 6.1- Opcion de instalar los microservicios utilizados solo declarando la auto instrumentacion para enviarlo al alloy de trazas (paso 5.1)
````
  -  kubectl apply -f .\clustering\multiple\apps\replicaset-apps-with-auto-Instrumentation.yml 

````
## 6.2- instalar los microservicios utilizamdp el Sidecar de otel y utilizando la instrumentacion manual (paso 5.2)
````
  -  kubectl apply -f .\clustering\multiple\apps\replicaset-apps-with-sidecar-otel.yml 

````
## 6.3- instalar los microservicios utilizamdp el Sidecar de otel y utilizando la instrumentacion automatica (paso 5.3)
````
  -  kubectl apply -f .\clustering\multiple\apps\replicaset-apps-auto-sidecar-otel.yml 

````
## 6.4- usando instalacion limpia sin nada  (Esta Opcion es para probar el limpio la recoleccion de alloy sin trazas) 
````
  - kubectl apply -f .\clustering\multiple\apps\replicaset-apps.yml 

```` 
