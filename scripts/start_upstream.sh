cat /ssh/key.pub > /root/.ssh/authorized_keys
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@" &
HOSTIP=$(route | awk '/default/ { print $2 }')
sed -i "s/172.17.0.1/$HOSTIP/" /etc/angie/angie.conf
if [ -n $AUTHUSER ]; then
    touch /etc/angie/.htpasswd
  else
    htpasswd -c -b /etc/angie/.htpasswd $AUTHUSER $AUTHPASSWD
fi
angie -g "daemon off;"
