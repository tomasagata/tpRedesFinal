# Informe Redes y Protocolos de Area Amplia

## Introducción

### Elementos del repositorio

1. bw_restricted_topo.py : Topografía original del trabajo. Se hace uso de la API de Mininet, y como controlador se utiliza OpenVSwitch
2. ftpclient.sh : Comienza el emisor FTP. Ejecutar en el host h1.
3. ftpserver.sh : Comienza el receptor FTP. Ejecutar en el host h2.
4. udpclient.sh : Comienza el emisor de Video en tiempo real. Ejecutar en el host h3.
5. udpserver.sh : Comienza el receptor de Video en tiempo real. Ejecutar en el host h4.
6. qos_tc_basic.sh : Define las reglas de calidad de servicio estándar. Hace uso de una cola FIFO simple. Ejecutar para evaluar el desempeño cuando no se definen reglas de QoS.
7. qos_tc_bandwidth_resrv.sh : Define y reserva un ancho de banda determinado para Video, y otro para trafico FTP. Ejecutar para evaluar el desempeño cuando se definen enlaces virtuales para cada tráfico.
8. qos_tc_fifo_fast.sh : Subdivide una cola FIFO en tres canales: 0, 1 y 2. Cuando hay tráfico en el canal 0, no se puede enviar tráfico del canal 1 ni 2. Cuando no hay tráfico en el canal 0, se procede a enviar trafico del canal 1; y si no hay trafico en ambos, se procede a enviar trafico del último canal. Los paquetes se asignan en cada canal dependiendo de su campo de ToS en el encabezado IP.
9. fix_x11.sh : debe utilizarse si se hace uso de la tecnología X11 mediante SSH antes de comenzar una sesión x11.
    

### ¿Cómo ejecutar?

Primero, se necesita tener instalado Mininet, Openflow, Python, y Traffic Control (tc) en Linux.
En segundo lugar, si se esta utilizando ssh para ejecutar las pruebas, es necesario ejecutar fix_x11.sh. De lo contrario, saltar este paso.
```bash
$ ./fix_x11.sh
```
Habiendo hecho eso, se debe iniciar la topología de Mininet.
```bash
$ sudo python3 bw_restricted_topo.py
```
Una vez dentro de la consola de Mininet, podemos seleccionar el tipo de calidad de servicio a probar.
```
mininet> sh ./qos_tc_basic.sh
``` 
si buscamos emplear ningún tipo de calidad de servicio
```
mininet> sh ./qos_tc_bandwidth_resrv.sh
```
si deseamos probar el desempeño cuando se utilizan enlaces virtuales para los tráficos
```
mininet> sh ./qos_tc_fifo_fast.sh
```
si deseamos probar el desempeño cuando se hace uso de canales por tipo de servicio.

Una vez determinado el tipo de QoS a utilizar, debemos realizar las pruebas. Para ello, primero debemos tener acceso a los hosts desde donde enviaremos y recibiremos el tráfico. Para ello ejecutamos desde la consola de mininet
```
mininet> xterm h1 h2 h3 h4
```
IMPORTANTE:
en el caso de que no ocurra nada, probar con ejecutar la corrección de X11
```
mininet> sh ./fix_x11.sh
```
y si sigue sin funcionar, probar a reiniciar el equipo y comenzar con las intrucciones desde cero con el comando
```
mininet> sh sudo reboot now
```

Una vez abiertas las ventanas de los distintos hosts, comenzaremos iniciando los receptores
```
[h2] $ ./ftpserver.sh
```
```
[h4] $ ./udpserver.sh
```
y luego los emisores
```
[h1] $ ./ftpclient.sh
```
```
[h3] $ ./udpclient.sh
```
