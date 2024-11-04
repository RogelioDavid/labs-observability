
# ARQUITECTURA DE REFERENCIA DE LA EJECUCION DEL LABORATORIO 

El laboratorio creado gracias las colaboraciones desde Grafana Labs Community consiste en como a nivel macro deberia montarse el proceso de migrar una arquitectura bajo concepto solucion End-To-End conocido como Application observability  

Este ejercicio  invita conocer como realizar recoleccion de Logs, Metricas y Trazas , todo con el uso de el Modo Flow del agente de grafana donde   Application observability  es compatible de forma nativa con OpenTelemetry y Prometheus y le permite combinar la telemetría de aplicaciones con datos de las capas de infraestructura y frontend en Grafana Cloud.

Application observability   invita a definir el como se realizara la generacion de metricas para las trazas (Grafana Cloud traces metric generation) donde entrega los siguientes modo soporte:
 
 ````
 - Tempo (Grafana Cloud) : donde debe ser usado Tempo 
 - Otel / Agent / alloy : donde permite que converse la unificacion de configuraciones  Entre otel y el agente como Otel con Alloy(flow mode) 
 - Legacy : coexistente entre Agent estatico con Otel-Collector
````  

Por otro lado  mantiene los Mismo Pros / Cons del modo estatico, ademas maneja procesamiento de diferentes tipos de telemetría en diferentes instancias del Agente de Grafana:

````
 - Con el mismo archivo de configuración de River tenemos diferentes tipos de recolección de señales que requieren diferentes métodos de escalado:
   - Los componentes "pull" como prometheus.scrape y pyroscope.scrape se escalan mediante el uso compartido de hashmod o la agrupación en clústeres.
   - Los componentes "push" como otelcol.receiver.otlp se escalan colocando un equilibrador de carga delante de ellos.
 - Uso Flexible de Sampling para las trazas (Head sampling / Tail sampling)
````


# ESTRUCTURA DE COMPONENTES 

## Grafana Agente / Operador 
 - Este componente podra estar concevido tanto en un deployment / StafefulSet / DaemonSet para la recoleccion de Metricas , Trazas y Logs
 - Contara con una configuracion con lenguaje homologo llamado RIVER 
 - Mantender la captura de informacion de:
   - los exportadores de la infraestructura
   - Service Mesh
 - se adicionara la captura en modo operador de trazas por el estandar Otel
  
 ## Open Telemetry

 - Este componente esta configurado para soportar el modo Sidercar el cual convive con los microservicios:





![picture](Grafana_Agent_Flow_Mode.png)




# PASOS PARA LEVANTA GRAFANA ALLOY

## 1 - Crear Cluster
````
  - make create-cluster-simple 
  -  gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a --project sparta-proyect-host 
  -  gcloud container clusters get-credentials autopilot-cluster-app --region us-central1 --project sparta-proyect-host
```` 

## 2.- creacion de nameSpaces
````
   - kubectl apply -f .\minifiest\cluster\00-namespace.yaml
````

## 3.- instalar los Custom Resource para soportar Open Telemetry Collector

````
  - kubectl apply  -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
  - kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
````

## 4.- instalacion Grafana Alloy

````
   -  kubectl apply -f .\grafana-alloy\crud-atomic\alloy\
   -  
````


## 5.1- instalar la declaracion de auto-instrumentacion hacia grafana-alloy

````
  - kubectl apply -f .\grafana-alloy\crud-atomic\otel-config-Instrumentation.yaml
````
## 5.2- instalar el collector en modo side card apuntando al grafana-agent

````
  - kubectl apply -f .\grafana-alloy\crud-atomic\otel-config-sidecar.yaml
````

## 6.1- instalar los microservicios utilizados sin utilizacion de Sidecar de otel 
````
  -  kubectl apply -f .\minifiest\apps\replicaset-apps-auto.yml 

````
## 6.2- usando instalacion limpia sin nada 
````
  - kubectl apply -f .\minifiest\apps\replicaset-apps.yml 

````




https://github.com/grafana/k8s-monitoring-helm/tree/main