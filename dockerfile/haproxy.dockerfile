ARG image
FROM $image
RUN apk add openssh-server haproxy \
    && mkdir -p /root/.ssh
ENV ENV="/root/.ashrc"