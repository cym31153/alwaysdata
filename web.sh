#!/bin/bash
mkdir corn
TMP_DIRECTORY=$(mktemp -d)

UUID='6e73420a-e015-455b-94b4-c28b1c299d7e'
VMESS_WSPATH='/cornvm'
VLESS_WSPATH='/cornvl'

URL=${USER}.alwaysdata.net

wget -q -O $TMP_DIRECTORY/config.json https://github.com/trendy31152x/disk/raw/refs/heads/main/config.json
wget -q -O $TMP_DIRECTORY/web.zip https://github.com/trendy31152x/disk/raw/refs/heads/main/tmp.zip
unzip -oq -d $HOME/corn $TMP_DIRECTORY/web.zip cornweb geoip.dat geosite.dat

sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#$VMESS_WSPATH#g;s#VLESS_WSPATH#$VLESS_WSPATH#g;s#10000#8300#g;s#20000#8400#g;s#127.0.0.1#0.0.0.0#g" $TMP_DIRECTORY/config.json
cp $TMP_DIRECTORY/config.json $HOME/corn
rm -rf $HOME/admin/tmp/*.*

Advanced_Settings=$(cat <<-EOF

ProxyRequests off
ProxyPreserveHost On
ProxyPass "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
ProxyPassReverse "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
ProxyPass "${VLESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8400${VLESS_WSPATH}"
ProxyPassReverse "${VLESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8400${VLESS_WSPATH}"
EOF
)

vmlink=vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"hicairo.com\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$VMESS_WSPATH\",\"tls\":\"tls\"}" | base64 -w 0)
vllink="vless://"$UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$VLESS_WSPATH"#alwaysdata"

qrencode -o $HOME/www/M$UUID.png $vmlink
qrencode -o $HOME/www/L$UUID.png $vllink

Author=$(cat <<-EOF
EOF
)

mkdir -p $HOME/www/


wget https://github.com/HFIProgramming/mikutap/archive/refs/heads/master.zip -O $HOME/master.zip


unzip $HOME/master.zip -d $HOME/
mv $HOME/mikutap-master/* $HOME/www/


rm $HOME/master.zip
rm -r $HOME/mikutap-master


cat > $HOME/www/corn.html<<-EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Alwaysdata</title>
<style type="text/css">
body {
      font-family: Geneva, Arial, Helvetica, san-serif;
    }
div {
      margin: 0 auto;
      text-align: left;
      white-space: pre-wrap;
      word-break: break-all;
      max-width: 80%;
      margin-bottom: 10px;
}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div><font color="#009900"><b>VMESS协议链接：</b></font></div>
<div>$vmlink</div>
<div><font color="#009900"><b>VMESS协议二维码：</b></font></div>
<div><img src="/M$UUID.png"></div>
<div><font color="#009900"><b>VLESS协议链接：</b></font></div>
<div>$vllink</div>
<div><font color="#009900"><b>VLESS协议二维码：</b></font></div>
<div><img src="/L$UUID.png"></div>
</body>
</html>
EOF

clear

echo -e "\e[32m$Author\e[0m"

echo -e "\n\e[33m请 COPY 以下绿色文字到 SERVICE Command* 中：\n\e[0m"
echo -e "\n\e[33m请 COPY 以下绿色文字到 Advanced Settings 中：\n\e[0m"
echo -e "\e[32m$Advanced_Settings\e[0m"

echo -e "\e[32mhttps://$URL/corn.html\n\e[0m"
