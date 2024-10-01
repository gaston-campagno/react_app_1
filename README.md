La App es una app de React. 

Tengo 3 workflows diferentes.

Uno con el que construyo la infra en AWS e instalo en la instancia EC2 lo necesrio para correr el cluster de Kubernets.
Seteo tambien la configuracion del Security Group y asigon par de claves SSh.
Este wokrflow lo ejecuto manualmente.

El segundo workflow es de CI y publish. 
Este se ejecuta sobre main cuando hay un pull request hacia ella desde otra rama.
Esto evita que cada rama feature sea publicada. Recien al mergearla, se buildea, se ejecutan los test unitarios, y finalmente se Dockeriza y sube a ECR, repositorio para imagenes Docker de AWS.

El tercer workflow, se ejecuta cuando el anterior finaliza exitosamente, y es el workflow de despliegue, o Deploy.
A travez de SSH me conecto a la instancia EC2, y aplico los manifiestos de deploy para kubernetes. Tanto para desplegar mi app que la traigo a la EC2 desde ECR, como para Prometheus y Grafana.

Finalmente las 3 apps se sirve en diferentes puertos, a los que se accede con la Elastic IP seteada, o sea un a ip fija.

APP: http://18.220.242.204:30000/

PROMETHEUS: http://18.220.242.204:31090/

GRAFANA: http://18.220.242.204:31000/
