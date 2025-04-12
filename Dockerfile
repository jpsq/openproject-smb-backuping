FROM ubuntu:20.04

# Instalamos smbclient y tar
RUN apt-get update && apt-get install -y smbclient tar && rm -rf /var/lib/apt/lists/*

# Copiamos el script de backup
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Ejecutamos el script en un bucle según BACKUP_FREQ
CMD ["sh", "-c", "while true; do /usr/local/bin/backup.sh; sleep ${BACKUP_FREQ}m; done"]
