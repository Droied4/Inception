# syntax=docker/dockerfile:1
FROM alpine:3.20@sha256:43180c492a5e6cedd8232e8f77a454f666f247586853eecb90258b26688ad1d3

ARG NGINX_PORT

EXPOSE ${NGINX_PORT}

WORKDIR /etc/niginx/

COPY ./conf/nginx.conf .

WORKDIR /usr/share/nginx/html

RUN apk update && \
	apk add --no-cache nginx && \
	echo "<html><body><h1>¡Hola, Nginx está funcionando!</h1></body></html>" > /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
