FROM alpine:3.20.6

WORKDIR /usr/share/nginx

COPY conf/nginx.conf ./
RUN <<EOF
echo "Nginx"
apk update
apk add nginx
echo "instalado"
EOF
