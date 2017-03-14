FROM registry.tstllc.net/llisk/alpine-base:latest

# Dev-Ops Team
MAINTAINER dl_team_devops@tstllc.net

RUN wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.2.tgz;

RUN tar zxf mongodb-linux-x86_64-3.4.2.tgz;

RUN set -ex && \
	apk add --no-cache --virtual .build-deps \
				     build-base  \
                                     curl        \
                                     git         \
                                     tar &&      \
	cd /tmp && \
	curl -sSL $URL | tar xz --strip 1 && \
	./configure --prefix=/usr \
                --sysconfdir=/etc/pureftpd \
                --without-humor \
                --with-minimal \
                --with-throttling \
                --with-puredb \
                --with-rfc2640 \
                --with-peruserlimits \
                --with-ratios \
                --with-welcomemsg && \
	make install-strip && \
	cd .. && \
	rm -rf /tmp/* && \
	apk del .build-deps && \
	echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk add --no-cache mongodb && \
	rm /usr/bin/mongosniff /usr/bin/mongoperf

VOLUME /data/db
EXPOSE 27017 28017

COPY run.sh /root
ENTRYPOINT [ "/root/run.sh" ]
CMD [ "mongod" ]
