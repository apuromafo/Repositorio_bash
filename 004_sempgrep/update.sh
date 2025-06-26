#!/bin/bash

# Script para actualizar y preparar las reglas de Semgrep

set -e  # Salir inmediatamente si un comando falla.

# Variables
RULE_DIR="/root/semgrep_rules"
LOG_FILE="/var/log/semgrep_update.log" # Mejor ubicación para logs

# Función para registrar mensajes en el log
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 1. Validar la existencia del directorio de reglas
if [ ! -d "$RULE_DIR" ]; then
  log "Error: El directorio '$RULE_DIR' no existe."
  echo "Error: El directorio '$RULE_DIR' no existe. Por favor, crea el directorio y asegúrate de que Semgrep esté instalado correctamente."
  exit 1
fi

# 2. Validar la versión de Semgrep (opcional pero recomendado)
SEMGREP_VERSION=$(python3 -m pip show semgrep | grep Version: | awk '{print $2}')
if [ -z "$SEMGREP_VERSION" ]; then
  log "Error: No se pudo determinar la versión de Semgrep."
  echo "Error: No se pudo determinar la versión de Semgrep. Asegúrate de que Semgrep esté instalado correctamente."
  exit 1
fi

log "Semgrep version: $SEMGREP_VERSION"


# 3. Actualizar Semgrep
log "Actualizando Semgrep..."
python3 -m pip install --upgrade semgrep

# 4. Preparar el directorio de reglas
log "Preparando el directorio de reglas..."
rm -rf "$RULE_DIR"
mkdir -p "$RULE_DIR"
git clone --depth 1 https://github.com/semgrep/semgrep-rules "$RULE_DIR"

# 5. Limpiar las reglas (¡CUIDADO!)
log "Limpiando las reglas..."
rm -f "$RULE_DIR/.pre-commit-config.yaml"
rm -rf "$RULE_DIR/stats/"
rm -rf "$RULE_DIR/.github"

# 6. Verificar la actualización (opcional)
log "Verificando la actualización..."
ls -l "$RULE_DIR"

log "Actualización de Semgrep completada con éxito."
