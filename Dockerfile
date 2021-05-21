FROM ubuntu:latest

RUN export DEBIAN_FRONTEND="noninteractive" \
	&& export TZ="Europe/Paris" \
	&& apt update \
    && apt upgrade -y \
	&& apt install apache2 php php-curl git locales -y \
	&& apt autoremove -y
RUN rm -f /var/www/html/index.html
RUN git clone https://github.com/AL-dot-debug/nWatch.git /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
RUN export DEBIAN_FRONTEND="noninteractive" \
	&& export TZ="Europe/Paris" \
	&& dpkg-reconfigure -f noninteractive tzdata \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen \
	&& echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
	&& echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& update-locale LANG=en_US.UTF-8
VOLUME /var/www/html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]