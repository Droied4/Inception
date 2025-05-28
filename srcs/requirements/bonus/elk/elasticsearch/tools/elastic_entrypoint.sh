#!/bin/sh

check_env()
{
	echo "Environment ready!"
}

init_service()
{
	check_env
	#curl elastic and configure
	exec "$@" -f /dev/null
}

if [ "$1" = "tail" ]; then
	init_service "$@"
else
	exec "$@"
fi
