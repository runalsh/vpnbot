cat /ssh/key.pub > /root/.ssh/authorized_keys
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@" &
HOSTIP=$(route | awk '/default/ { print $2 }')
sed -i "s/172.17.0.1/$HOSTIP/" /etc/angie/angie.conf
angie -g "daemon off;"
