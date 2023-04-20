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
ENV VERSION='1.20.0'

# build frontend
WORKDIR /go/src/github.com/kyamo/accweb/public
RUN cp src/components/end.vue src/components/end.vue.orig
RUN sed -i "s/%VERSION%/$VERSION/g" src/components/end.vue
RUN sed -i "s/%COMMIT%/release/g" src/components/end.vue
RUN npm i
RUN npm run build
RUN mv src/components/end.vue.orig src/components/end.vue

# build backend
WORKDIR /go/src/github.com/kyamo/accweb
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o accweb cmd/main.go

# copy files
RUN cp build/sample_config.yml config.yml

# make scripts and accweb executable
RUN chmod +x ./accweb


# Final image
FROM debian:bullseye

COPY --from=builder /go/src/github.com/kyamo/accweb /accweb

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

# später aktivieren
# RUN apk update && apk add gettext wine
RUN apt-get update && apt-get install -y gettext-base wine64 wine libwine ca-certificates

# Install wine32
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libwine wine32

EXPOSE 8080

ENTRYPOINT [ "/accweb/build/docker/docker-entrypoint.sh" ]
