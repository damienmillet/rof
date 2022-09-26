FROM alpine:latest

ARG TARGETARCH

EXPOSE 3000/tcp

VOLUME [ "/config","downloads" ]

ENV TIMEZONE Europe/Paris

RUN apk update && apk upgrade && apk add  --no-cache rtorrent nano curl mediainfo openvpn sudo \
  && rm -rf /var/cache/apk/*

RUN echo $TARGETARCH

RUN wget "https://github.com/jesec/flood/releases/download/v4.7.0/flood-linux-$TARGETARCH" -O /usr/bin/flood \
  && chmod +x /usr/bin/flood

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/bin/sh","/app/entrypoint.sh" ]
