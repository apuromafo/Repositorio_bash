#!/bin/bash

# Este script actualiza Kali Linux y maneja la clave del repositorio.
# Detecta si están presentes wget o curl para descargar la clave.

echo "[*] Actualización del sistema Kali Linux iniciada."

# Función para descargar la clave, usa wget o curl según disponibilidad
download_key() {
  if command -v wget > /dev/null 2>&1; then
    echo "[*] Usando wget para descargar la nueva clave..."
    sudo wget https://archive.kali.org/archive-keyring.gpg  -O /usr/share/keyrings/kali-archive-keyring.gpg
  elif command -v curl > /dev/null 2>&1; then
    echo "[*] Usando curl para descargar la nueva clave..."
    sudo curl https://archive.kali.org/archive-keyring.gpg  -o /usr/share/keyrings/kali-archive-keyring.gpg
  else
    echo "[ERROR] No se encontró 'wget' ni 'curl'. Instálalos e inténtalo de nuevo."
    exit 1
  fi
}

# Comprobamos si existe el directorio keyrings
if [ ! -d "/usr/share/keyrings" ]; then
  echo "[*] Creando directorio /usr/share/keyrings..."
  sudo mkdir -p /usr/share/keyrings
fi

# Descargamos la clave
download_key

# Verificación opcional de la integridad del archivo GPG
echo "[*] Verificando la integridad de la clave..."
sha1sum /usr/share/keyrings/kali-archive-keyring.gpg | grep -q "603374c107a90a69d983dbcb4d31e0d6eedfc325"
if [ $? -eq 0 ]; then
  echo "[OK] La firma de la clave es correcta."
else
  echo "[WARN] La firma de la clave no coincide. Puede haber problemas con la descarga."
fi

# Actualizamos la lista de paquetes
echo "[*] Actualizando la lista de paquetes..."
sudo apt update

# Actualizamos los paquetes
echo "[*] Actualizando paquetes..."
sudo apt upgrade -y

# Actualización completa del sistema
echo "[*] Aplicando dist-upgrade..."
sudo apt dist-upgrade -y

# Limpiamos paquetes obsoletos
echo "[*] Limpiando paquetes innecesarios..."
sudo apt autoclean -y && sudo apt autoremove -y

echo "[*] ¡Sistema actualizado correctamente!"