FROM alpine:3.12.0

LABEL maintainer="VU <vishal@gmail.com>"

# hadolint ignore=DL3018
RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync

ENV VERSION 0.73.0

WORKDIR /usr/local/src

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN curl -k -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz \
      | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl --head --fail localhost:1313 || exit 1
