#!/bin/sh

envsubst < /mdb.cnf.template > /etc/my.cnf

# Lanzar el servidor como usuario mysql
exec su-exec mysql $@
