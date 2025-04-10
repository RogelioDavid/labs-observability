
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

## 1 - Crear Cluster (PAra esto debes tener tu propia cuenta y tener seatdo SDK de google para trabajar en tu proyecto)
````
  - make create-cluster-simple-2 
  -  gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a --project sparta-proyect-host 
 
```` 

## 2.- creacion de nameSpaces
````
   - kubectl apply -f .\minifiest\cluster\00-namespace.yaml
````

## 3.- instalar los Custom Resource para soportar Open Telemetry Collector

````
  - kubectl apply  -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.5/cert-manager.yaml
  - kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
````

## 4.- instalacion Grafana Alloy

````
   -  kubectl apply -f .\grafana-alloy\crud-atomic\alloy\logs\
   -  kubectl apply -f .\grafana-alloy\crud-atomic\alloy\metrics\
   -  kubectl apply -f .\grafana-alloy\crud-atomic\alloy\traces\
````

# MANIFIESTOS PARA LA UTILIZACION DE OPEN-TELEMETRY

## 5.1- instalar la opcion de auto-instrumentacion para enviarlo al alloy de trazas hacia grafana-alloy

````
si se busca usar la opcion de probar todo auto-instrumentado 

  - kubectl apply -f .\grafana-alloy\crud-atomic\otel\otel-config-auto-Instrumentation.yaml


si se busca usar la opcion de probar auto-instrumentado en java y node con instrumentacion estandar manual 

  - kubectl apply -f .\grafana-alloy\crud-atomic\otel\otel-config-auto-Instrumentation-only-java-no-node.yaml


Esta opcion permite probar declaraciones de multiples auto-instrumentacion para considerar el contextualizacion de varios tipos de colectores

  - kubectl apply -f .\grafana-alloy\crud-atomic\otel\otel-config-multiple-auto-Instrumentation.yaml



````

## 5.2- instalar la opcion de collector en modo Sidecar de otel y utilizando la instrumentacion manual hacia al collector grafana-alloy de trazas

````
  - kubectl apply -f .\grafana-alloy\crud-atomic\otel\otel-config-sidecar.yaml
````

## 5.3- instalar la opcion de collector en modo Sidecar y auto-instrumentacion , solo para inyectar el agente pero en nivel de sidecar de enviar al collector alloy de trazas 

````
  - kubectl apply -f .\grafana-alloy\crud-atomic\otel\otel-config-sidecard-with-auto-instrumentacion.yml
````

# MANIFIESTOS PARA INSTANAR LA APLICACION

## 6.1- Opcion de instalar los microservicios utilizados solo declarando la auto instrumentacion para enviarlo al alloy de trazas (paso 5.1) y ejecutando la anotacion a nivel de namespace



````
Agregar las anotaciones de un solo manifiesto de auto-instrumentacion  (otel-config-auto-Instrumentation.yaml | otel-config-auto-Instrumentation-only-java-no-node.yaml)
  - make kubectl-add-annotations-java-auto-instrumentation
  - make kubectl-add-annotations-node-auto-instrumentation

````
````
Agregar las anotaciones de instrumentacion  con multiple auto-instrumentacion (otel-config-multiple-auto-Instrumentation.yaml)
  - make kubectl-add-annotations-java-m-auto-instrumentation
  - make kubectl-add-annotations-node-m-auto-instrumentation

````
````

si se busca usar la opcion de probar todo auto-instrumentado 

  - kubectl apply -f .\minifiest\apps\replicaset-apps-with-auto-Instrumentation-all.yml 

si se busca usar la opcion de probar auto-instrumentado en java y node con instrumentacion estandar manual 

  - kubectl apply -f .\minifiest\apps\replicaset-apps-with-auto-Instrumentation-java.yml 

````



## 6.2- instalar los microservicios utilizamdp el Sidecar de otel y utilizando la instrumentacion manual (paso 5.2)
````
  -  kubectl apply -f .\minifiest\apps\replicaset-apps-with-sidecar-otel.yml 

````
## 6.3- instalar los microservicios utilizamdp el Sidecar de otel y utilizando la instrumentacion automatica (paso 5.3)
````
  -  kubectl apply -f .\minifiest\apps\replicaset-apps-auto-sidecar-otel.yml 

````
## 6.4- usando instalacion limpia sin nada  (Esta Opcion es para probar el limpio la recoleccion de alloy sin trazas) 
````
  - kubectl apply -f .\minifiest\apps\replicaset-apps.yml 

```` 




https://github.com/grafana/k8s-monitoring-helm/tree/main