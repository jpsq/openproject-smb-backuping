#!/bin/bash

# Variables de entorno
BACKUP_DIR=/backups
SMB_SERVER=${SMB_SERVER}
SMB_USER=${SMB_USER}
SMB_PASS=${SMB_PASS}
SMB_SHARE=${SMB_SHARE}  # Recurso compartido (ej: BK-Samba/bases)
ASSETS_DIR=/var/openproject/assets
PGDATA_DIR=/var/openproject/pgdata

# Fecha para el nombre del archivo de backup
DATE=$(date +\%Y-\%m-\%d_\%H-\%M)

# Separar el recurso compartido de la ruta interna
SHARE_NAME=$(echo $SMB_SHARE | cut -d'/' -f1)  # Recurso compartido (ej: BK-Samba)
SHARE_PATH=$(echo $SMB_SHARE | cut -d'/' -f2-) # Ruta interna (ej: bases/subcarpeta)

# Log: Iniciando backup
echo "$(date +'%Y-%m-%d %H:%M:%S') - Iniciando backup de los archivos de OpenProject..."

# Comprimir las carpetas de OpenProject (assets y pgdata)
tar -czf $BACKUP_DIR/openproject_assets_$DATE.tar.gz -C $ASSETS_DIR . 
tar -czf $BACKUP_DIR/openproject_pgdata_$DATE.tar.gz -C $PGDATA_DIR .

# Log: Subiendo backup al servidor SMB
echo "$(date +'%Y-%m-%d %H:%M:%S') - Subiendo backup a //$SMB_SERVER/$SMB_SHARE..."

# Cambiar al directorio de backups
cd $BACKUP_DIR

# Subir los backups al servidor SMB
if smbclient //$SMB_SERVER/$SHARE_NAME -U $SMB_USER%$SMB_PASS -c "cd $SHARE_PATH; put openproject_assets_$DATE.tar.gz; put openproject_pgdata_$DATE.tar.gz"; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup subido correctamente a //$SMB_SERVER/$SMB_SHARE."
else
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Error: No se pudo subir el backup al servidor SMB."
    rm -f openproject_assets_$DATE.tar.gz openproject_pgdata_$DATE.tar.gz  # Limpiar los archivos locales en caso de error
    exit 1
fi

# Limpiar los archivos locales del backup comprimido
rm -f openproject_assets_$DATE.tar.gz openproject_pgdata_$DATE.tar.gz

# Log: Proceso completado
echo "$(date +'%Y-%m-%d %H:%M:%S') - Proceso de backup completado correctamente."
