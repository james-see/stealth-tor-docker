############################################################
# Dockerfile to build UBUNTU with Tor hidden SSH
# Based on Ubuntu:XENIAL (16.04)
# Author: James Campbell https://jamescampbell.us
############################################################
FROM ubuntu:xenial
# File Author / Maintainer
MAINTAINER James Campbell
RUN apt-get update
################## BEGIN INSTALLATION ######################
RUN apt-get install install --yes tor openssh-server


# Create hidden service folder
RUN mkdir -p /var/lib/tor/ssh_onion_service/
RUN chown -R debian-tor:debian-tor /var/lib/tor/ssh_onion_service/
RUN chmod 0700 /var/lib/tor/ssh_onion_service/

# Add settings for SSH connection
RUN echo "" >> /etc/tor/torrc
RUN echo "#Hidden service for SSH connections." >> /etc/tor/torrc
RUN echo "HiddenServiceDir /var/lib/tor/ssh_onion_service/" >> /etc/tor/torrc
# Create authentication token
RUN AUTH="$(< /dev/urandom tr -dc a-z0-9 | head -c16)"
RUN echo "HiddenServiceAuthorizeClient stealth $AUTH" >> /etc/tor/torrc
RUN echo "HiddenServicePort 22 127.0.0.1:51984" >> /etc/tor/torrc

RUN service tor restart

RUN sed -i 's/Port 22/Port 51984/g' /etc/ssh/sshd_config
RUN service ssh restart

# Build examples of .ssh/config and /etc/tor/torrc
RUN echo ""CONNECTION="$(cat /var/lib/tor/ssh_onion_service/hostname)" ONION="$(echo $CONNECTION | cut -d' ' -f1)"
RUN echo "# Add this to your .ssh/config in client side"
RUN echo "host hidden"
RUN echo -e '\thostname $ONION'
RUN echo -e '\tuser root'
RUN echo -e '\tproxyCommand /usr/local/bin/ncat --proxy 127.0.0.1:9050 --proxy-type socks5 %h %p'
RUN echo ""
RUN echo "Add this line to your /etc/tor/torrc on client side."
RUN echo "HidServAuth $CONNECTION"
RUN echo ""
ENTRYPOINT /bin/bash
