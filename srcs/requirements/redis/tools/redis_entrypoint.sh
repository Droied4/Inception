#!/bin/sh 

set -e

configure_user()
{
	user=$1
	group=$2
	
	 if ! getent group "$group" > /dev/null 2>&1; then
	 	echo "Add group $group"
	 	addgroup -S "$group";
	 fi
	 if ! getent passwd "$user" > /dev/null 2>&1; then
	 	echo "Add user $user"
	 	adduser -S -D -G "$group" "$user";
	 fi
}

init_redis()
{
	#configure_user "redis" "redis"
	exec "$1"
}

init_redis $@

if [ "$1" = "redis-server" ]; then
	init_redis $@
else
	exec "$@"
fi
