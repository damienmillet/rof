# set dns
echo 'nameserver 1.1.1.1' > /etc/resolv.conf

if [ ! "$(id -u rtorrent)" ]; then
    # create user rtorrent
    addgroup rtorrent
    adduser -S rtorrent rtorrent
    sudo -S -u rtorrent curl -Ls "https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md" \
    | sudo -S -u rtorrent sed -ne "/^######/,/^### END/p" \
    | sudo -S -u rtorrent sed -re "s:USERNAME:rtorrent:" > /home/rtorrent/.rtorrent.rc
    sudo -S -u rtorrent sed -i "s:#system.daemon.set = true:system.daemon.set = true:" /home/rtorrent/.rtorrent.rc
    sudo -S -u rtorrent sed -i "s:#network.scgi.open_local = (cat,(session.path),rpc.socket):network.scgi.open_local = (cat,(session.path),rpc.socket):" /home/rtorrent/.rtorrent.rc
    sudo -S -u rtorrent sed -i "s:#execute.nothrow = chmod,770,(cat,(session.path),rpc.socket):execute.nothrow = chmod,770,(cat,(session.path),rpc.socket):" /home/rtorrent/.rtorrent.rc
    sudo -S -u rtorrent sed -i "s:network.port_range.set = 50000-50000:network.port_range.set = 16881-16881:" /home/rtorrent/.rtorrent.rc

    sudo -S -u rtorrent mkdir -p /home/rtorrent/rtorrent/
fi

# if vpn isn't on, stop rtorrent if it's running and run vpn if file conf exist
# if vpn is on, start rtorrent if it's not running
while true; do
    if ! pgrep openvpn > /dev/null || '0' == ifconfig | grep tun0 | wc -l ; then
        if pgrep rtorrent > /dev/null; then
          echo "OpenVPN is not running, stopping rtorrent..."
          killall rtorrent
          sleep 5
        fi
        echo "OpenVPN is not running, restarting..."
        if [ -f /config/client.ovpn ]; then
            echo "Starting OpenVPN..."
            openvpn --config /config/client.ovpn --daemon
            sleep 5
        else
            echo "No OpenVPN configuration found in /config. Exiting..."
            exit 1
        fi
        sleep 5
    else 
        if ! pgrep rtorrent > /dev/null; then
          echo "OpenVPN is running, starting rtorrent..."
          sudo -S -u rtorrent  rtorrent&
          sleep 5
        fi
    fi
    sleep 5
done

sudo -S -u rtorrent flood --host 0.0.0.0
