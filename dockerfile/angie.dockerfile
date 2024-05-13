ARG image
FROM alpine

RUN set -x \
     && apk add --no-cache ca-certificates curl \
     && curl -o /etc/apk/keys/angie-signing.rsa https://angie.software/keys/angie-signing.rsa \
     && echo "https://download.angie.software/angie/alpine/v$(egrep -o \
          '[0-9]+\.[0-9]+' /etc/alpine-release)/main" >> /etc/apk/repositories \
     && apk add --no-cache angie openssh-server angie-console-light apache2-utils \
     && rm /etc/apk/keys/angie-signing.rsa \
     # && ln -sf /dev/stdout /var/log/angie/access.log \
     # && ln -sf /dev/stderr /var/log/angie/error.log \
     && mkdir -p /root/.ssh \
     && mkdir -p /var/cache/angie

ENV ENV="/root/.ashrc"

CMD ["angie", "-g", "daemon off;"]