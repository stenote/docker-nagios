FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

ARG NAGIOS_VERSION=4.3.1  
ARG NAGIOS_PLUGIN_VERSION=2.1.4

RUN apt-get update \
	&& apt-get -y install \
	    wget \
	    build-essential \
	    apache2 \
	    apache2-utils \
	    php7.0-gd \
	    libgd2-xpm-dev \
	    libapache2-mod-php7.0 \
	    msmtp \
	    mutt \
	    unzip \
	    libssl-dev \
	    openssh-client \
	    iputils-ping \
	    libwww-perl \
	    libcrypt-ssleay-perl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd --system --home /usr/local/nagios -M nagios \
	&& groupadd --system nagcmd \
	&& usermod -a -G nagcmd nagios \ 
	&& usermod -a -G nagcmd www-data \
	&& a2enmod cgi

RUN cd /tmp  \
	&& wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-${NAGIOS_VERSION}.tar.gz \
	&& tar -zxvf nagios-${NAGIOS_VERSION}.tar.gz \
	&& cd /tmp/nagios-${NAGIOS_VERSION}  \
	&& ./configure \
		--with-nagios-group=nagios \
		--with-command-group=nagcmd \
		--with-mail=/usr/sbin/sendmail \
		--with-httpd_conf=/etc/apache2/conf-available \
	&& make all \
	&& make install \
	&& make install-init \
	&& make install-config \
	&& make install-commandmode \
	&& make install-webconf \
	&& cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/ \
	&& chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers \
	&& ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios \
	&& rm -rf /tmp/nagios-${NAGIOS_VERSION}*

RUN cd /tmp \
	&& wget http://www.nagios-plugins.org/download/nagios-plugins-${NAGIOS_PLUGIN_VERSION}.tar.gz \
	&& tar -zxvf nagios-plugins-${NAGIOS_PLUGIN_VERSION}.tar.gz \
	&& cd /tmp/nagios-plugins-${NAGIOS_PLUGIN_VERSION} \
	&& ./configure \
		--with-nagios-user=nagios \
		--with-nagios-group=nagios \
		--enable-perl-modules \
		--enable-extra-opts \
		--with-ssh-command=/usr/bin/ssh \
	&& make \
	&& make install \
	&& rm -rf /tmp/nagios-plugins-${NAGIOS_PLUGIN_VERSION}*

COPY files/root /

EXPOSE 80

VOLUME /usr/local/nagios/etc/

ENTRYPOINT ["/entrypoint.sh"]
