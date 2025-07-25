# syntax=docker/dockerfile:1
ARG BASE_DIGEST=43180c492a5e6cedd8232e8f77a454f666f247586853eecb90258b26688ad1d3
FROM alpine@sha256:${BASE_DIGEST}

ARG MARIADB_PORT
ARG MARIADB_SCRIPT

RUN 	apk update && \
	    apk add --no-cache \
		mariadb \
		su-exec \ 
		mariadb-client

RUN	mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

COPY 	--chmod=755 ${MARIADB_SCRIPT}mdb_entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE ${MARIADB_PORT}
CMD ["mysqld"]
