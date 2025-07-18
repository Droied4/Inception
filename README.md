# INCEPTION
---
Inception is a project I recently completed. Its main goal is to use Docker to set up containers and deploy various services from scratch, using minimal base images such as Alpine or Debian. In my case, I chose Alpine for its lightness and simplicity.

Throughout the development process, I made an effort to follow best practices, both in terms of file organization and the configuration and security of the services and containers.

## Guide
I leave the link to a Docker guide that I wrote on Medium explaining basic concepts necessary to solve the project.
https://medium.com/@deiord44santiagoov/inception-guia-42-school-8f32ccefda19 

## Services
### Nginx
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nginx/nginx-original.svg" width="180" height="180" alt="Nginx" />
Reverse proxy and web server for routing traffic to other containers.

### Wordpress
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/wordpress/wordpress-original.svg" width="180" height="180" alt="Wordpress" />
Content management system served via PHP-FPM.

### Mariadb
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mariadb/mariadb-original.svg" width="180" height="180" alt="Mariadb" />
Lightweight MySQL-compatible database for WordPress data.

### Redis
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" width="180" height="180" alt="Redis" />
In-memory key-value store used for caching.

### Vsftpd
<img src="https://www.redeszone.net/app/uploads-redeszone.net/2019/11/image.psd180.jpg?quality=80" width="180" height="180" alt="Adminer" />
Secure FTP server to upload and manage files.

### Adminer
<img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/adminer.svg" width="180" height="180" alt="Adminer" />
Lightweight database management tool to interact with MariaDB.

### Healthcheck
<img src="https://cdn.prod.website-files.com/652ee4abdcbbba956ecb7d8f/66674c6c99ddb274f12d3b01_pulse_3914586.png" width="180" height="180" alt="Adminer" />
Custom script that verifies all services are running properly.

## Architecture Diagram

![architecture diagram](./assets/arquitectura_inception.svg)
