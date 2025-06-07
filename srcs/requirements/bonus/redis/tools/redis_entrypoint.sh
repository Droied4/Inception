#!/bin/sh 

set -e

config_file()
{
	dir=$1

	sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" $dir
	sed -i "s|# maxmemory <bytes>|maxmemory 2mb|g" $dir
	sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" $dir
}

init_redis()
{
	config_file "/etc/redis.conf"
	exec "$1" --protected-mode no
}

init_redis $@

if [ "$1" = "redis-server" ]; then
	init_redis $@
else
	exec "$@"
fi
