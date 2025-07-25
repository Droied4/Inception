# syntax=docker/dockerfile:1
ARG BASE_DIGEST=43180c492a5e6cedd8232e8f77a454f666f247586853eecb90258b26688ad1d3  
FROM alpine@sha256:${BASE_DIGEST}

ARG NGINX_PORT
ARG NGINX_SCRIPT

RUN 	apk update && \
	    apk add --no-cache nginx \ 
		gettext \
		openssl

COPY --chmod=644 ${NGINX_SCRIPT}nginx.cnf.template /
COPY --chmod=744 ${NGINX_SCRIPT}nginx_entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE ${NGINX_PORT}
CMD ["nginx", "-g", "daemon off;"]
