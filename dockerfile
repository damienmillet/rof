FROM alpine:latest

EXPOSE 3000/tcp

VOLUME [ "/config","downloads" ]

ENV TIMEZONE Europe/Paris

RUN apk update && apk upgrade && apk add  --no-cache rtorrent nano curl mediainfo npm openvpn sudo \
  && rm -rf /var/cache/apk/*

RUN npm install -g flood && npm cache clean --force

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/bin/sh","/app/entrypoint.sh" ]
