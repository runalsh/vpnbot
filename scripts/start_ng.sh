cat /ssh/key.pub > /root/.ssh/authorized_keys
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@" &
sed "s/ss:[0-9]\+/ss:$SSPORT/" /angie_default.conf > change_port
cat change_port > /angie_default.conf
sed "s/ss:[0-9]\+/ss:$SSPORT/" /etc/angie/angie.conf > change_port
cat change_port > /etc/angie/angie.conf
HOSTIP=$(route | awk '/default/ { print $2 }')
sed -i "s/172.17.0.1/$HOSTIP/" /etc/angie/angie.conf
htpasswd -c -b /etc/angie/.htpasswd $AUTHUSER $AUTHPASSWD
angie -g "daemon off;"
