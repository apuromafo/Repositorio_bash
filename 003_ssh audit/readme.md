 # 🔐 SSH Protection Audit Script

> **Script Bash para auditoría de protección SSH contra ataques de fuerza bruta**

Este script realiza una auditoría de seguridad sobre hosts en una red o IP específica para detectar servidores SSH que **no tengan protección contra ataques de fuerza bruta**. Además:

- Crea **copias de seguridad antes de cualquier cambio**
- Detecta hosts con SSH abierto
- Simula intentos fallidos de conexión
- Si el host no bloquea conexiones → lo banea automáticamente usando **Fail2Ban**
- Genera un informe detallado
- Muestra todo en una interfaz interactiva con `dialog`

---

## 📦 Requisitos

Asegúrate de tener instaladas las siguientes herramientas (el script las instala si faltan):

| Herramienta     | Descripción                          |
|------------------|--------------------------------------|
| `fail2ban`       | Protección contra intentos repetidos |
| `sshpass`        | Autenticación SSH simulada           |
| `nmap`           | Escaneo de puertos                   |
| `bc`             | Cálculos matemáticos                 |
| `dialog`         | Interfaz gráfica en terminal          |
| `sed`            | Manipulación de texto                |
| `iptables` / `ufw` | Firewall (opcional)                  |

---

## ⚙️ Instalación Rápida

```bash
chmod +x ssh_protection_audit.sh
sudo ./ssh_protection_audit.sh
```

> El script debe ejecutarse como **root**

---

## 🧪 ¿Qué hace este script?

1. **Pregunta al usuario:**
   - Red/Host objetivo
   - Puerto SSH (por defecto 22)
   - Número máximo de intentos permitidos
   - Nombre del archivo de informe

2. **Luego realiza:**
   - Escaneo de hosts con puerto SSH abierto
   - Intentos simulados de conexión SSH con credenciales inválidas
   - Detección de si el host bloquea los intentos
   - Baneo automático con Fail2Ban si no hay protección
   - Generación de informe `.txt` con resultados

3. **Antes de realizar cambios:**
   - Crea **copias de seguridad** de configuraciones importantes:
     - Archivo de configuración de Fail2Ban
     - Reglas actuales de firewall (`iptables` o `ufw`)

---

## 📁 Copias de Seguridad

Todas las configuraciones importantes se respaldan antes de cualquier cambio y se guardan en:

```
/opt/ssh_audit_backup/
```

Ejemplos:
- `/opt/ssh_audit_backup/jail.local.before.YYYYMMDDHHMMSS`
- `/opt/ssh_audit_backup/iptables.before.txt`
- `/opt/ssh_audit_backup/ufw.before.txt`
- `/opt/ssh_audit_backup/ufw.added.before.txt`

---

## 📝 Informe Final

Se genera un archivo `.txt` con información detallada de cada host escaneado, incluyendo:

- Host/IP
- Estado de protección
- Si fue baneado o no

---

## 🛡️ ¿Quieres revertir los cambios?

Sí, puedes restaurar manualmente desde las copias de seguridad guardadas en:

```
/opt/ssh_audit_backup/
```

 

## ✅ Licencia

Este proyecto está bajo la [Licencia MIT](LICENSE). Puedes usarlo, modificarlo y distribuirlo libremente.

