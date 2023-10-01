#!/bin/sh

# create release directory
VDIR="accweb"
DIR="$VDIR"
mkdir -p "$DIR"

# build frontend
cd public
cp src/components/end.vue src/components/end.vue.orig
npm i
npm run build
mv src/components/end.vue.orig src/components/end.vue

# build backend
cd ..
CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o $DIR/accweb cmd/main.go

# copy files
cp LICENSE "$DIR/LICENSE"
cp README.md "$DIR/README.md"
cp build/sample_config.yml "$DIR/config.yml"

# make scripts and accweb executable
chmod +x "$DIR/accweb"