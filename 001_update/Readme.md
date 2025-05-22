
# Script de Actualización de Kali Linux

Este script ofrece una forma completa de actualizar tu sistema Kali Linux, asegurando que tus paquetes estén al día y gestionando la clave GPG del repositorio para una administración segura de los paquetes. Detecta automáticamente si `wget` o `curl` están disponibles para descargar la clave.

## Características

* **Gestión Automatizada de Claves:** Descarga e instala el keyring (anillo de claves) más reciente del archivo de Kali Linux.
* **Detección de Herramientas:** Utiliza inteligentemente `wget` o `curl` para descargar la clave, dependiendo de cuál esté presente.
* **Verificación de Integridad de la Clave:** Comprueba la suma SHA1 de la clave GPG descargada para asegurar su autenticidad.
* **Actualización Completa del Sistema:** Realiza `apt update`, `apt upgrade` y `apt dist-upgrade` para una actualización completa del sistema.
* **Limpieza de Paquetes:** Elimina automáticamente paquetes innecesarios y limpia el repositorio local de archivos de paquetes recuperados.
* **Salida Informativa:** Proporciona mensajes claros sobre el progreso del script y cualquier posible problema.

## Requisitos

Este script está diseñado para **Kali Linux**. Requiere privilegios de `sudo` para realizar actualizaciones y modificaciones en todo el sistema. También depende de que `wget` o `curl` estén instalados para descargar la clave GPG. Si ninguno de los dos está presente, el script te indicará que instales uno.

## Uso

1.  **Guarda el script:** Guarda el contenido del script en un archivo, por ejemplo, `actualizar_kali.sh`.

2.  **Dale permisos de ejecución:** Abre tu terminal, navega hasta el directorio donde guardaste el script y ejecuta:
    ```bash
    chmod +x actualizar_kali.sh
    ```

3.  **Ejecuta el script:** Ejecuta el script desde tu terminal con privilegios de `sudo`:
    ```bash
    sudo ./actualizar_kali.sh
    ```

    El script te guiará a través del proceso de actualización, mostrando mensajes en cada etapa.

## Cómo Funciona

El script realiza los siguientes pasos:

1.  **Comprueba `wget` o `curl`**: Primero determina qué utilidad está disponible para descargar la clave GPG.
2.  **Crea el directorio `keyrings`**: Si `/usr/share/keyrings` no existe, lo crea.
3.  **Descarga la clave GPG**: Descarga el archivo `kali-archive-keyring.gpg` desde `https://archive.kali.org/` a `/usr/share/keyrings/`.
4.  **Verifica la integridad de la clave**: Calcula la suma SHA1 de la clave descargada y la compara con un hash conocido y correcto (`603374c107a90a69d983dbcb4d31e0d6eedfc325`).
5.  **Actualiza las listas de paquetes**: Ejecuta `sudo apt update`.
6.  **Actualiza los paquetes**: Ejecuta `sudo apt upgrade -y`.
7.  **Realiza una actualización de distribución**: Ejecuta `sudo apt dist-upgrade -y` para actualizaciones importantes del sistema.
8.  **Limpia**: Ejecuta `sudo apt autoclean -y && sudo apt autoremove -y` para liberar espacio.

---