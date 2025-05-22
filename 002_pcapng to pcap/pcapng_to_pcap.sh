#!/bin/bash

# Nombre de la idea: pcapng to pcap

echo "--- Convertidor de .pcapng a .pcap ---"
echo ""

# --- Validación de editcap ---
echo "Verificando la disponibilidad de 'editcap'..."
if ! command -v editcap &> /dev/null
then
    echo "Error: 'editcap' no se encontró."
    echo "Parece que Wireshark o sus herramientas CLI no están instaladas o no están en tu PATH."
    echo "Por favor, instala Wireshark (o el paquete de herramientas CLI si está separado para tu OS) e inténtalo de nuevo."
    exit 1
fi
echo "'editcap' encontrado. ¡Continuando!"
echo ""
# --- Fin de la validación ---


# Preguntar por el nombre del archivo de entrada
read -p "Introduce el nombre del archivo de entrada (ej: mi_captura.pcapng): " input_file

# Verificar si el archivo de entrada existe
if [ ! -f "$input_file" ]; then
    echo "Error: El archivo '$input_file' no se encontró."
    exit 1
fi

# Preguntar por el nombre del archivo de salida
read -p "Introduce el nombre del archivo de salida (ej: salida.pcap): " output_file

# Ejecutar el comando editcap
echo "Convirtiendo '$input_file' a '$output_file'..."
editcap -F libpcap -T ether "$input_file" "$output_file"

# Verificar el código de salida de editcap
if [ $? -eq 0 ]; then
    echo "¡Conversión completada exitosamente!"
    echo "Archivo de salida: $output_file"
else
    echo "Error: La conversión falló. Revisa los mensajes de error de 'editcap'."
fi

echo "-------------------------------------"