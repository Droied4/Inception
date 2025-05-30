#!/bin/sh

check_env()
{
	echo "Environment ready!"
}

add_group()
{
	group=$1
	user=$2
	dir=$3

	if ! getent group "$group" ; then
		echo "Creating group $group"
    		groupadd --system "$group"
	fi
	if ! getent passwd "$user" ; then
		echo "Creating user $user"
    		useradd --system -g "$group" "$user"
	fi
}


download_elastic()
{
	elastic_version=$1
	curl -L -o elastic.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$elastic_version-linux-x86_64.tar.gz && \
	tar -xzf elastic.tar.gz && \
	rm elastic.tar.gz
	echo "Elasticsearch installed!"
}

config_elastic()
{
	echo "Elastic configured!"
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
	dir=/elasticsearch-${ELASTIC_VERSION}
	user=elasticuser
	check_env
	add_group "elasticgroup" "$user" "$dir"
	download_elastic ${ELASTIC_VERSION}
	config_elastic
	prepare_exec "$user" "elasticgroup" "$dir"
	exec gosu $user "$@"
}

if [ "$1" = "./elasticsearch" ]; then
	init_service "$@"
else
	exec "$@"
fi
