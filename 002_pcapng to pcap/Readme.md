
# pcapng to pcap Converter

Este es un script simple de Bash diseñado para convertir archivos de captura de red del formato `.pcapng` (NGPCAP) al formato `.pcap` (Libpcap) utilizando la herramienta `editcap` de Wireshark.

## Características

* **Fácil de Usar:** Interfaz de línea de comandos que solicita los nombres de los archivos de entrada y salida.
* **Validación:** Verifica si la herramienta `editcap` está disponible en tu sistema antes de intentar la conversión.
* **Mensajes de Estado:** Proporciona retroalimentación clara sobre el éxito o fracaso de la conversión.


## ¿Por qué usar este script?

Algunas herramientas de análisis de tráfico de red (como ciertas versiones de Tcpdump, Snort o Bro)
 aún no soportan completamente el formato moderno `.pcapng`. Este script te permite fácilmente convertir tus archivos `.pcapng` a `.pcap` 
 para asegurar compatibilidad con sistemas legacy o herramientas específicas.



## Requisitos

Para que este script funcione correctamente, necesitas tener **Wireshark** (o al menos sus herramientas de línea de comandos, que incluyen `editcap`) instalado en tu sistema.

### Instalación de Wireshark (Ejemplos)

* **Debian/Ubuntu:**
    ```bash
    sudo apt update
    sudo apt install wireshark
    ```
* **Fedora:**
    ```bash
    sudo dnf install wireshark
    ```
* **Arch Linux:**
    ```bash
    sudo pacman -S wireshark-cli
    ```
* **macOS (con Homebrew):**
    ```bash
    brew install wireshark
    ```
* **Windows:** Descarga el instalador desde el [sitio oficial de Wireshark](https://www.wireshark.org/download.html).

## Uso

1.  **Guarda el script:** Guarda el contenido del script en un archivo, por ejemplo, `convert_pcap.sh`.

2.  **Dale permisos de ejecución:**
    ```bash
    chmod +x convert_pcap.sh
    ```

3.  **Ejecuta el script:**
    ```bash
    ./convert_pcap.sh
    ```

    El script te pedirá que ingreses el nombre del archivo `.pcapng` de entrada y el nombre deseado para el archivo `.pcap` de salida.

## Ejemplo de Ejecución

```bash
$ ./convert_pcap.sh
--- Convertidor de .pcapng a .pcap ---

Verificando la disponibilidad de 'editcap'...
'editcap' encontrado. ¡Continuando!

Introduce el nombre del archivo de entrada (ej: mi_captura.pcapng): mi_trafico.pcapng
Introduce el nombre del archivo de salida (ej: salida.pcap): trafico_convertido.pcap
Convirtiendo 'mi_trafico.pcapng' a 'trafico_convertido.pcap'...
¡Conversión completada exitosamente!
Archivo de salida: trafico_convertido.pcap
-------------------------------------
```

---