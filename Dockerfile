FROM ghcr.io/toshy/php:8.3-fpm-bookworm AS local

ARG UID=${UID:-10000}
ARG GID=${GID:-10001}
ARG USER=${USER:-webapp}

RUN addgroup \
    --gid $GID \
    --system $USER \
    && adduser \
    --uid $UID \
    --disabled-password \
    --gecos "" \
    --ingroup $USER \
    --no-create-home \
    $USER

COPY .docker/php/conf.d $PHP_INI_DIR/conf.d/

COPY .docker/php/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.${USER}.conf

FROM local AS curl-impersonate

ARG CURL_IMPERSONATE_VERSION='v0.8.2'

RUN <<EOT bash
  set -ex
  curl -L --retry 3 --retry-connrefused --retry-delay 2 --fail-with-body -o /tmp/curl-impersonate.tar.gz https://github.com/lexiforest/curl-impersonate/releases/download/${CURL_IMPERSONATE_VERSION}/curl-impersonate-${CURL_IMPERSONATE_VERSION}.x86_64-linux-gnu.tar.gz
  tar -xzf /tmp/curl-impersonate.tar.gz -C /usr/local/bin --no-same-owner
  curl -L --retry 3 --retry-connrefused --retry-delay 2 --fail-with-body -o /tmp/libcurl-impersonate.tar.gz https://github.com/lexiforest/curl-impersonate/releases/download/${CURL_IMPERSONATE_VERSION}/libcurl-impersonate-${CURL_IMPERSONATE_VERSION}.x86_64-linux-gnu.tar.gz
  tar -xzf /tmp/libcurl-impersonate.tar.gz -C /tmp --no-same-owner
  mv /tmp/libcurl-impersonate-* /usr/lib/x86_64-linux-gnu/
  rm -f /tmp/*
  ldconfig
EOT

ENV CURL_IMPERSONATE=chrome131
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libcurl-impersonate-chrome.so.4.8.0