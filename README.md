# Entrega 1 del proyecto WP01

* Juan Sebastián Otálora Quiroga 
* Natalia Álvarez Gallo

## Entrega definicion de Proyecto

Con las herramientas adquiridas en el transcurso del semestre, se busca el desarrollo de un proyecto final en verilog, que se sintetizara en la FPGA del grupo, ademas de la adicion de perifericos para obtener un funcionamiento especifico.

El tamagochi fue una pequeña mascota portatil la cual consistia en el cuidado de una mascota virtual, donde se debia controlar parametros tales como salud, limpieza, habitos de sueño y alimentacion. El fin de este proyecto es desarrollar una pequeña mascota portatil con el uso de modulos de verilog sintetizados en la FPGA Cyclone IV (EP4CE10E22C8N).

![Cyclone VI](imagenes/FPGA.jpg)



## Requerimientos

 * Una interfaz de usuario operada mediante botones físicos.
 * Al menos un sensor para ampliar las formas de interacción.
 * Un sistema de visualización para representar el estado actual y las necesidades de la mascota virtual.

## Especificaciones

A continuacion se describirá el hardware y su implementacion en el proyecto: 

### La mascota

Esta presentara cambios visuales en funcion de su estado que variara de manera binaria 

 * Animo
 * Salud
 * Hambre
 * Comodidad

 La visualizalizacion general cambiara dependiendo de la suma de los estados, 
  





### Visualizacion

Para la visualizacion de la mascota virtual, se considerara el uso de estados, es decirl por cada estado de la mascota se mostrara una "imagen" en pantalla, esta cambiara dependiendo de la suma de los estados que presente.

Esta se realizara con una pantalla de 8x8 leds con un modulo MAX7219, el cual plantea una comunicacion tipo SPI, siento el MAX7219 el esclavo y la GPGA el master de la comunicacion.

![Esquema del display de 7 segmentos](imagenes/8x8_image.webp)


                        ___________________
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0   0 0   0 0 |
    Patron 1            | 0 0 0 0 0 0 0 0 |
                        | 0   0 0 0 0   0 |
                        | 0 0         0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        |-----------------|


                        ___________________
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0   0 0   0 0 |
    Patron 2            | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0             0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        |-----------------|


                        ___________________
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0   0 0   0 0 |
    Patron 3            | 0 0 0 0 0 0 0 0 |
                        | 0 0 0 0 0 0 0 0 |
                        | 0 0         0 0 |
                        | 0   0 0 0 0   0 |
                        | 0 0 0 0 0 0 0 0 |
                        |-----------------|



                          _______________
                         |               |
                clk -----|               |
                rst -----|               |
      data_in [7:0] -----|               |---- sclk
              start -----|               |---- mosi
     freq_div[15:0] -----|               |---- miso             data_out  [7:0] <----|               |---- cs
               busy <----|               |
              avail <----|               |
                         |_______________|






