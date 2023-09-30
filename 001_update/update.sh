#!/bin/bash

# Este script actualiza un sistema en mi caso ,  Kali Linux.

# Actualiza la lista de paquetes disponibles.
sudo apt update

# Actualiza los paquetes instalados a la última versión.
# El modificador -y acepta automáticamente las actualizaciones.
sudo apt upgrade -y

# Realiza una actualización completa del sistema, que puede incluir la actualización del kernel del sistema operativo.
# El modificador -y acepta automáticamente las actualizaciones.
sudo apt dist-upgrade -y

# Limpia el caché de paquetes y elimina los paquetes que ya no son necesarios.
# El modificador -y acepta automáticamente las operaciones.
sudo apt autoclean -y && sudo apt autoremove -y