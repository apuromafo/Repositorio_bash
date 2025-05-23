#!/bin/bash

# Nombre del script principal
SCRIPT_NAME="pcapng_to_pcap.sh"
MAIN_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$SCRIPT_NAME"

# Verificar que el script principal exista
if [ ! -f "$MAIN_SCRIPT_PATH" ]; then
    echo "Error: No se encontró '$SCRIPT_NAME' en $(dirname "$MAIN_SCRIPT_PATH")"
    exit 1
fi

# Dar permisos de ejecución al script
chmod +x "$MAIN_SCRIPT_PATH"

# Detectar el terminal disponible
TERMINAL_EXEC=""
if command -v gnome-terminal &>/dev/null; then
    TERMINAL_EXEC="gnome-terminal --"
elif command -v konsole &>/dev/null; then
    TERMINAL_EXEC="konsole -e"
elif command -v xterm &>/dev/null; then
    TERMINAL_EXEC="xterm -e"
else
    TERMINAL_EXEC="xterm -e"
    echo "No se detectó un terminal conocido, usando 'xterm' como fallback."
fi

# Directorios de escritorio y aplicaciones
DESKTOP_DIR="$HOME/Escritorio"
[[ ! -d "$DESKTOP_DIR" ]] && DESKTOP_DIR="$HOME/Desktop" # Para inglés

APPS_DIR="$HOME/.local/share/applications"

mkdir -p "$DESKTOP_DIR" "$APPS_DIR"

# Nombre del lanzador
DESKTOP_FILE_NAME="pcap-converter.desktop"
DESKTOP_FILE_PATH="$APPS_DIR/$DESKTOP_FILE_NAME"

ICON_PATH="$HOME/.local/share/icons/pcap-converter-icon.png"

# Crear directorio de iconos si no existe
mkdir -p "$(dirname "$ICON_PATH")"

# Copiar o descargar un ícono dummy (opcional)
if [ ! -f "$ICON_PATH" ]; then
    echo "Descargando ícono dummy..."
    wget -O "$ICON_PATH" "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Terminal_icon.svg/512px-Terminal_icon.svg.png " &>/dev/null || touch "$ICON_PATH"
fi

# Crear archivo .desktop
cat > "$DESKTOP_FILE_PATH" <<EOL
[Desktop Entry]
Name=PCAPng to PCAP Converter
Comment=Convierte archivos pcapng a formato pcap usando editcap
Exec=$TERMINAL_EXEC sudo "$MAIN_SCRIPT_PATH"
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;Network;
StartupNotify=false
EOL

# Hacerlo ejecutable
chmod +x "$DESKTOP_FILE_PATH"

# Opcional: copiar al escritorio
cp "$DESKTOP_FILE_PATH" "$DESKTOP_DIR/"

# Mensaje final
echo ""
echo "✅ ¡Instalación completada!"
echo "🔹 Script instalado: $MAIN_SCRIPT_PATH"
echo "🔹 Acceso rápido creado en: $DESKTOP_DIR"
echo "🔹 Terminal detectado: $TERMINAL_EXEC"
echo "🔹 Puedes hacer clic derecho → 'Confianza' y permitir ejecución (en algunos sistemas)"
echo ""
echo "⚠️ Si no ves el icono, reinicia el entorno gráfico o usa:"
echo "   killall xfdesktop4 && xfdesktop4 &   # XFCE"
echo "   nautilus -q && nautilus &            # GNOME"