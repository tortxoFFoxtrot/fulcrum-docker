FROM ubuntu:latest AS build
RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -yq && apt install -yq gpg wget sudo \
  && arch="$(dpkg --print-architecture)"; case "$arch" in \arm64) wget https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-arm64-linux.tar.gz ;; \
  \amd64) wget https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-x86_64-linux.tar.gz ;; esac; \
  wget -O hashes https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-shasums.txt \
  && wget -O hashes.asc https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-shasums.txt.asc \
  && wget -O sign_key.asc https://fulcrumserver.org/calinkey.txt && gpg --import sign_key.asc \
  && gpg --list-keys --fingerprint --with-colons | sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' | gpg --import-ownertrust \
  && gpg --keyid-format long --verify hashes.asc hashes && sha256sum -c --ignore-missing hashes && echo "verified signed archive" && sleep 10 \
  && case "$arch" in \arm64) tar -xvf Fulcrum-1.11.0-arm64-linux.tar.gz --strip-components=1 ;; \
  \amd64) tar -xvf Fulcrum-1.11.0-x86_64-linux.tar.gz --strip-components=1 ;; esac;

ENTRYPOINT ["/bin/sh","/config/init.sh"]
