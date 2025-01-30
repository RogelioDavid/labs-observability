# PREPARACION LABORATORIO PARA REVISAR TEMAS CON EL COLLECTOR DE OPEN TELEMETRY EN MODO OPERATOR

 ## REALIZAR CREACION DEL CLUSTER PUBLICO
  - make create-cluster-simple 
  -  gcloud container clusters get-credentials autopilot-cluster-app --zone=us-central1-a --project sparta-proyect-host 
 

 ## ESPACIOS  DE NOMBRES
 - kubectl apply -f .\minifiest\cluster\00-namespace.yaml


## PREPARA COLLECTOR EN MODO OPERADOR PARA LA AUTO-ISTRUMENTACION
 - kubectl apply  -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
 - kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml


## UTILIZARCION DE OPCIONES DE CONFIGURACION DEL COLLECTOR
###  OPCION CON FILTROS 
  - kubectl apply -f .\minifiest\otel\1.2otel-config-auto.yaml

###  OPCION SIMPLE
  - kubectl apply -f .\minifiest\otel\1.1otel-config-auto.yaml
  

###   INSTALACION DE MICROSERVICIOS CON AUTO-INSTRUMENACION 
  - Opcion 1 : kubectl apply -f .\minifiest\apps\deployment-apps-auto.yml 
  - Opcion 2 : kubectl apply -f .\minifiest\apps\replicaset-apps-auto.yml