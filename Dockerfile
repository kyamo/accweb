# Builder
FROM golang:1.21.1-bullseye AS builder

LABEL maintainer="kyamo" \
      version="latest" \
      description="Assetto Corsa Competizione Server Management Tool via Web Interface."

COPY . /go/src/github.com/kyamo/accweb

WORKDIR /go/src/github.com/kyamo/accweb

ENV NODE_MAJOR=16
ENV GOPATH=/go
ENV VERSION='1.21.0'

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \ 
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean

# build frontend
WORKDIR /go/src/github.com/kyamo/accweb/public
RUN cp src/components/end.vue src/components/end.vue.orig && \
    sed -i "s/%VERSION%/$VERSION/g" src/components/end.vue && \
    sed -i "s/%COMMIT%/release/g" src/components/end.vue

RUN npm i && \
    npm run build && \
    mv src/components/end.vue.orig src/components/end.vue

# build backend
WORKDIR /go/src/github.com/kyamo/accweb
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o accweb cmd/main.go

# copy files
RUN cp build/sample_config.yml config.yml

# make scripts and accweb executable
RUN chmod +x ./accweb


# Final image
FROM debian:12-slim

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

RUN apt-get update && \
    apt-get install -y gettext-base wine64 wine libwine ca-certificates

EXPOSE 8080

ENTRYPOINT [ "/accweb/build/docker/docker-entrypoint.sh" ]
