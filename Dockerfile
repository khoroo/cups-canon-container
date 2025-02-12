FROM ghcr.io/anujdatar/cups

ARG TARGETARCH

RUN apt-get update -qq && apt-get install -qqy wget

ENV CANON_URL="https://gdlp01.c-wss.com/gds/8/0100007658/44/linux-UFRII-drv-v600-m17n-06.tar.gz"
ENV CANON_SHA256="7714fa6eee1a04e96ec6fbf44d3cfb25a4299db00bff9f765bc48a2528cfc0da"

WORKDIR /tmp

RUN wget -q $CANON_URL -O canon-driver.tar.gz && \
    echo "$CANON_SHA256  canon-driver.tar.gz" | sha256sum -c - && \
    tar -xf canon-driver.tar.gz && \
    \
    case "$TARGETARCH" in \
        amd64) DIR="x64" ;; \
        arm64) DIR="ARM64" ;; \
        *) echo "Unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac && \
    \
    cd linux-UFRII-drv-*/${DIR}/Debian && \
    apt-get install -qqy ./cnrdrvcups-ufr2*.deb && \
    \
    cd /tmp && \
    rm -rf linux-UFRII-drv* canon-driver.tar.gz

CMD ["/entrypoint.sh"]
