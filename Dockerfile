FROM centos:centos7

# Change sh to bash
RUN mv /bin/sh /bin/sh_origin && ln -s /bin/bash /bin/sh

# Intsall Basic packages
RUN yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y tmux vim tree \
    && yum install -y git curl openssl openssl-devel bzip2-devel readline-devel sqlite-devel \
    && yum install -y gcc systemd-devel

# Set Properties
ENV POSTFIX centos_7_64

# set user to tset Salt API through pam
RUN useradd -ms /bin/bash test \
    && echo test | passwd test --stdin

# Get & Set pyenv
RUN git clone https://github.com/pyenv/pyenv /root/.pyenv
ENV PYENV_HOME /root/.pyenv
ENV PATH $PYENV_HOME/bin:$PATH
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
RUN eval "$($pyenv init -)" \
    && pyenv install 2.7.13 \
    && pyenv global 2.7.13
ENV PATH /root/.pyenv/shims/:$PATH

# Download salt-2017.7.6
RUN curl -L -o /root/salt-2017.7.6.tar.gz https://drive.google.com/uc\?export\=download\&id\=1qTrEj7Gj0cTbLyXUgSxaufVK_5QVXVCD
RUN tar zxf /root/salt-2017.7.6.tar.gz -C /root \
    && mv /root/salt-2017.7.6 /root/salt

# Install salt-2017.7.6
WORKDIR /root/salt
RUN pip install --upgrade pip \
    && pip install -r requirements/dev_python27.txt \
    && pip install -r requirements/zeromq.txt \
    && python setup.py build --quiet \
    && python setup.py install --quiet \
    && pyenv rehash 

# Set masetr config & startup script
WORKDIR /root
RUN mkdir /etc/salt
ADD master /etc/salt/master
ADD start_salt_stack.sh /root/start_salt_stack.sh
RUN chmod 755 /root/start_salt_stack.sh

# Set minion config & start script
RUN mkdir /root/minion1-config \
    && mkdir /root/minion2-config \
    && mkdir /root/minion3-config
ADD minion1 /root/minion1-config/minion
ADD minion2 /root/minion2-config/minion
ADD minion3 /root/minion3-config/minion

# Set extmods & pillar
ADD salt_extmods /root/salt_extmods
ADD salt_pillar /root/salt_pillar

# Set execution permission
RUN chmod o+x /root && chmod o+x /root/.pyenv

# Check
RUN salt-master --versions
