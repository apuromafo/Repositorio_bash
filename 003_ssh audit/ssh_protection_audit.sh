#!/bin/bash

# Título del script
TITLE="SSH Protection Audit"

# Directorio de backup
BACKUP_DIR="/opt/ssh_audit_backup"
mkdir -p "$BACKUP_DIR"

# Verificar permisos de root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecute este script como root."
  exit 1
fi

# Función para crear backups
create_backup() {
  dialog --title "$TITLE" --infobox "Creando copias de seguridad..." 5 40
  sleep 1

  # Backup de jail.local si existe
  if [ -f /etc/fail2ban/jail.local ]; then
    cp /etc/fail2ban/jail.local "$BACKUP_DIR/jail.local.before.$(date +%Y%m%d%H%M%S)"
  fi

  # Backup de iptables o ufw
  if command -v iptables &>/dev/null; then
    iptables-save > "$BACKUP_DIR/iptables.before.txt"
  fi
  if command -v ufw &>/dev/null && ufw status | grep -q "active"; then
    ufw status verbose > "$BACKUP_DIR/ufw.before.txt"
    ufw show added > "$BACKUP_DIR/ufw.added.before.txt"
  fi
}

# Función para instalar dependencias
check_install() {
  for dep in "$@"; do
    if ! command -v "$dep" &>/dev/null; then
      dialog --title "$TITLE" --infobox "Instalando $dep..." 5 40
      sleep 1
      apt-get install -y "$dep" &>/tmp/audit_install.log
    fi
  done
}

# Inicio del menú principal
dialog --title "$TITLE" --msgbox "Bienvenido al auditor de protección SSH\nEste script verificará hosts y protegerá los vulnerables.\nSe crearán copias de seguridad antes de realizar cambios." 12 60

# Paso 1: Instalar dependencias
check_install fail2ban sshpass nmap bc dialog sed

# Paso 2: Crear backups
create_backup

# Reiniciar fail2ban por si es nueva instalación
systemctl restart fail2ban

# Paso 3: Pedir datos al usuario
tempfile=$(mktemp)

dialog --title "$TITLE" --form "Configuración de escaneo" 15 50 5 \
  "Red/Host objetivo:" 1 0 "192.168.1.0/24" 1 20 30 255 \
  "Puerto SSH (opcional):" 2 0 "" 2 20 30 5 \
  "Intentos máximos:" 3 0 "6" 3 20 30 2 \
  "Nombre del informe:" 4 0 "ssh_audit_report" 4 20 30 30 \
  2> "$tempfile"

if [ $? -ne 0 ]; then
  dialog --title "$TITLE" --msgbox "Operación cancelada." 5 30
  exit 1
fi

readarray -t inputs < "$tempfile"
network=${inputs[0]}
port=${inputs[1]}
max_attempts=${inputs[2]}
output_file="${inputs[3]}.txt"

rm -f "$tempfile"

# Validar datos
if [ -z "$network" ]; then
  dialog --title "$TITLE" --msgbox "Debe ingresar una red o IP válida." 5 40
  exit 1
fi

if [ -z "$port" ]; then
  port="22"
fi

if [ -z "$max_attempts" ] || [ "$max_attempts" -lt 1 ]; then
  max_attempts=6
fi

echo "Escaneando la red: $network en el puerto $port"
sleep 2

# Archivo temporal para almacenar hosts con SSH
scan_temp="/tmp/ssh_hosts.tmp"
nmap -Pn -p "$port" "$network" | grep "open" | awk '{print $1}' > "$scan_temp"

if [ ! -s "$scan_temp" ]; then
  dialog --title "$TITLE" --msgbox "No se encontraron hosts con SSH abierto." 5 50
  exit 1
fi

# Preparar archivo de salida
echo "Informe de Auditoría SSH" > "$output_file"
echo "Fecha: $(date)" >> "$output_file"
echo "Hosts escaneados: $network" >> "$output_file"
echo "Puerto: $port" >> "$output_file"
echo "Intentos máximos permitidos: $max_attempts" >> "$output_file"
echo "" >> "$output_file"

# Contador de hosts
total_hosts=$(wc -l < "$scan_temp")
current=0

while read -r host; do
  current=$((current + 1))
  percent=$((current * 100 / total_hosts))

  # Intentar conexiones SSH fallidas
  attempts=0
  blocked=false

  while [ "$attempts" -le "$max_attempts" ]; do
    sshpass -p "invalid_password" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o NumberOfPasswordPrompts=0 -l root -p "$port" "$host" 2>/tmp/ssh_test.log

    if ! grep -q 'Connection refused' /tmp/ssh_test.log && ! grep -q 'timed out' /tmp/ssh_test.log; then
      attempts=$((attempts + 1))
    else
      blocked=true
      break
    fi

    sleep 1
  done

  if [ "$blocked" = true ]; then
    status="Protección OK"
  else
    status="Sin protección"
    fail2ban-client set sshd banip "$host" &>/dev/null
    status+=" → Banneado con Fail2Ban"
  fi

  echo "$percent" | dialog --title "$TITLE - Progreso" --gauge "Analizando $host ($current/$total_hosts)\n$status" 10 70 0

  echo "Host: $host" >> "$output_file"
  echo "Estado: $status" >> "$output_file"
  echo "-----------------------------" >> "$output_file"

done < "$scan_temp"

rm -f "$scan_temp"

# Mostrar ubicación del backup
dialog --title "$TITLE" --msgbox "Auditoría completada.\nInforme guardado como: $output_file\nCopias de seguridad guardadas en: $BACKUP_DIR" 12 60