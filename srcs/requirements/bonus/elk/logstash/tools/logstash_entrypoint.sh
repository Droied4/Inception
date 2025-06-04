#!/bin/sh

check_env()
{
	echo "Environment ready!"
}

add_group()
{
	group=$1
	user=$2

	if ! getent group "$group" ; then
		echo "Creating group $group"
    		groupadd --system "$group"
	fi
	if ! getent passwd "$user" ; then
		echo "Creating user $user"
    		useradd --system -g "$group" "$user"
	fi
}

download_logstash()
{
	version=$1
	volume=$2
	cd $volume
	if [ ! -d $volume/logstash-$version ]; then
	echo "Installing Logstash"
	curl -L -o logstash.tar.gz https://artifacts.elastic.co/downloads/logstash/logstash-$version-linux-x86_64.tar.gz
	tar -xzf logstash.tar.gz && \
	rm logstash.tar.gz
	fi
	echo "Logstash installed!"
}

prepare_exec()
{
	user=$1
	group=$2
	path=$3
	chown -R $user:$group $path
	cd $path/bin/
}

init_service()
{
	volume=/usr/share/logstash
	dir=$volume/logstash-${LOGSTASH_VERSION}
	user=loguser
	group=loggroup
	check_env
	add_group "$group" "$user"
 	download_logstash "${LOGSTASH_VERSION}" "$volume"
	prepare_exec "$user" "$group" "$dir"
	exec gosu $user "$@"
}

if [ "$1" = "./logstash" ]; then
	init_service "$@"
else
	exec "$@"
fi
