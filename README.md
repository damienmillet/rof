# rtorrent-ovpn-flood

```docker-compose.yml
services:
  rof:
    image: damienmillet/rof:latest
    container_name: rof
    environment:
      - TZ=Europe/Paris
    volumes:
      - /path/config:/config
      - /path/downloads:/downloads
    ports:
      - "3000:3000"
```
