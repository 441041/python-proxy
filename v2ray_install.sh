wget "https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh" -O install-release.sh
. install-release.sh
echo "请输入端口"
read port
uuid=$(cat /proc/sys/kernel/random/uuid)
echo $uuid
echo "{
  \"inbounds\": [
    {
      \"port\": $port, 
      \"protocol\": \"vmess\",   
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"$uuid\",  
            \"alterId\": 0
          }
        ]
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\",  
      \"settings\": {}
    }
  ]
}" > /usr/local/etc/v2ray/config.json

echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr

sudo ufw allow $port/tcp
systemctl start v2ray