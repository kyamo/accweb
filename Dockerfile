# Builder
FROM golang AS builder

LABEL maintainer="kyamo" \
      version="latest" \
      description="Assetto Corsa Competizione Server Management Tool via Web Interface."

COPY . /go/src/github.com/kyamo/accweb

WORKDIR /go/src/github.com/kyamo/accweb

RUN apt update && \
	apt install curl  -y
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh && bash nodesource_setup.sh
RUN apt-get install -y nodejs

ENV GOPATH=/go

RUN ./build/build_release.sh

# Final image
FROM alpine:latest

COPY --from=build /go/src/github.com/kyamo/accweb /accweb

ENV ACCWEB_HOST=0.0.0.0:8080 \
	ACCWEB_ENABLE_TLS=false \
	ACCWEB_CERT_FILE=/sslcerts/certificate.crt \
	ACCWEB_PRIV_FILE=/sslcerts/private.key \
	ACCWEB_ADMIN_PASSWORD=weakadminpassword \
	ACCWEB_MOD_PASSWORD=weakmodpassword \
	ACCWEB_RO_PASSWORD=weakropassword \
	ACCWEB_LOGLEVEL=info \
	ACCWEB_CORS=*

VOLUME /accserver /accweb /sslcerts

WORKDIR /accweb

RUN apk update && apk add gettext wine

EXPOSE 8080

ENTRYPOINT [ "/bin/sh", "-c", "/accweb/build/docker/docker-entrypoint.sh" ] 