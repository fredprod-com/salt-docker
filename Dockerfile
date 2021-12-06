FROM        centos:7
MAINTAINER  Frederic Perrouin "frederic@fredprod.com"
ENV REFRESHED_AT 2021-12-06

# Update system
RUN	yum -y update

# Add Salt Official repository
ENV SALT_RELEASE=3003
RUN rpm --import https://repo.saltproject.io/py3/redhat/7/x86_64/$SALT_RELEASE/SALTSTACK-GPG-KEY.pub && \
    curl -fsSL https://repo.saltproject.io/py3/redhat/7/x86_64/$SALT_RELEASE.repo | tee /etc/yum.repos.d/salt.repo && \
    yum clean expire-cache && \
    yum -y install salt-master salt-minion

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor /etc/salt/master.d/reactor

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/log/salt", "/srv/salt"]

# Exposing salt master
EXPOSE 4505 4506

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
