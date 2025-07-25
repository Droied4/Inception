# syntax=docker/dockerfile:1
ARG BASE_DIGEST=43180c492a5e6cedd8232e8f77a454f666f247586853eecb90258b26688ad1d3
FROM alpine@sha256:${BASE_DIGEST}

ARG WP_PORT
ARG WP_SCRIPT
ARG WP_CONF
ARG PHP_VERSION

RUN	apk update && \
	apk add --no-cache \
		curl \
		php${PHP_VERSION} \
		php${PHP_VERSION}-fpm \ 
		php${PHP_VERSION}-mysqli \ 
		php${PHP_VERSION}-redis \
		php${PHP_VERSION}-ctype \
		php${PHP_VERSION}-phar \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-xml      \
		php${PHP_VERSION}-dom  \
		php${PHP_VERSION}-xmlreader \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-cli \
		php${PHP_VERSION}-zlib

COPY	--chmod=644 ${WP_CONF}wp-config.php /
COPY	--chmod=755 ${WP_SCRIPT}wp_entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE ${WP_PORT}
CMD ["php"]
