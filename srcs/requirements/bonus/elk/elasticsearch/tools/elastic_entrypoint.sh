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
	chown -R $user:$group $dir
	echo "Echo siiii"	
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

init_service()
{
	check_env
	download_elastic ${ELASTIC_VERSION}
	add_group "elasticgroup" "elasticuser" "elasticsearch-${ELASTIC_VERSION}"
	config_elastic
	#su elasticuser 
	#./elasticsearch-${ELASTIC_VERSION}/bin/elasticsearch
	exec "$@" -f /dev/null
}

if [ "$1" = "tail" ]; then
	init_service "$@"
else
	exec "$@"
fi
