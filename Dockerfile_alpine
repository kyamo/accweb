# Builder
FROM golang:alpine3.18 AS builder

LABEL maintainer="kyamo" \
      version="latest" \
      description="Assetto Corsa Competizione Server Management Tool via Web Interface."

COPY . /go/src/github.com/kyamo/accweb
WORKDIR /go/src/github.com/kyamo/accweb

ENV GOPATH=/go
ENV VERSION=v1.21.0

RUN apk add --update curl nodejs npm python3

# build frontend
WORKDIR /go/src/github.com/kyamo/accweb/public
RUN cp src/components/end.vue src/components/end.vue.orig && \
    sed -i "s/%VERSION%/$VERSION/g" src/components/end.vue && \
    sed -i "s/%COMMIT%/release/g" src/components/end.vue

RUN npm i && \
    npm install -g node-sass && \
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
FROM alpine:3.18

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

RUN apk add --update gettext wine ca-certificates 

EXPOSE 8080

ENTRYPOINT [ "/accweb/build/docker/docker-entrypoint.sh" ]
