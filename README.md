# OpenProject SMB Backuping

This repository contains a solution for backing up OpenProject data (assets and PostgreSQL data) to an SMB server. It uses Docker containers to run OpenProject and a backup service that periodically uploads compressed backups to the specified SMB share.

## Features

- Automated backups of OpenProject assets and PostgreSQL data.
- Compression of backup files to save space.
- Uploading backups to an SMB server.
- Configurable backup frequency via environment variables.
- Resource limits for containers to ensure efficient usage.

## Repository Structure

- `backup.sh`: Bash script to handle the backup process.
- `Dockerfile`: Defines the backup service container.
- `.env.example`: Example environment variables file.
- `docker-compose.yml`: Docker Compose configuration for OpenProject and the backup service.
- `.gitignore`: Specifies files and directories to be ignored by Git.

## Prerequisites

- Docker and Docker Compose installed on your system.
- An SMB server accessible with valid credentials.
- OpenProject data directories (`pgdata` and `assets`) available locally.

## Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/openproject-smb-backuping.git
   cd openproject-smb-backuping
   ```

2. **Configure environment variables**:
   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` to set your SMB server details, backup frequency, and other configurations.

3. **Prepare directories**:
   - Ensure the following directories exist:
     - `./pgdata`: For PostgreSQL data.
     - `./assets`: For OpenProject assets.
     - `./backups`: For temporary storage of backup files.

4. **Start the services**:
   ```bash
   docker-compose up -d
   ```

## Environment Variables

The `.env` file contains the following variables:

- `SMB_SERVER`: SMB server address.
- `SMB_USER`: SMB username.
- `SMB_PASS`: SMB password.
- `SMB_SHARE`: SMB share path (e.g., `Folder/subfolder`).
- `BACKUP_FREQ`: Backup frequency in minutes (e.g., `1440` for daily backups).
- `OPENPROJECT_SECRET_KEY_BASE`: Secret key for OpenProject.
- `OPENPROJECT_HOST__NAME`: Hostname for OpenProject.
- `OPENPROJECT_HTTPS`: Whether to use HTTPS (`true` or `false`).
- `OPENPROJECT_DEFAULT__LANGUAGE`: Default language for OpenProject.
- `VIRTUAL_HOST`, `LETSENCRYPT_HOST`, `LETSENCRYPT_EMAIL`: For reverse proxy and SSL configuration.

## Usage

- The backup service runs in a loop, executing the `backup.sh` script at the interval specified by `BACKUP_FREQ`.
- Backup files are compressed and temporarily stored in the `./backups` directory before being uploaded to the SMB server.

## Logs

To view logs for the backup service:
```bash
docker logs openproject_backup
```

## Resource Limits

- OpenProject container:
  - CPU: 1 core
  - Memory: 2 GB
- Backup container:
  - CPU: 0.5 core
  - Memory: 256 MB

## Network Configuration

The containers are configured to use an external Docker network named `nginx-proxy`. Ensure this network exists or modify the `docker-compose.yml` file to suit your setup.

## Troubleshooting

- **Backup upload fails**:
  - Check SMB server credentials in `.env`.
  - Ensure the SMB server is reachable from the host machine.
- **Containers not starting**:
  - Verify Docker and Docker Compose are installed and running.
  - Check for errors in the `docker-compose.yml` file.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
