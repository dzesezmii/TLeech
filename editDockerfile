FROM python:3.8-slim-buster

WORKDIR /app

ENV PIP_NO_CACHE_DIR 1
ENV LANG C.UTF-8
ENV TZ=Europe/London
ENV DEBIAN_FRONTEND=noninteractive

#us-east-1 eu-west-1
RUN sed -i.bak 's/eu-west-1\.ec2\.//' /etc/apt/sources.list && \
    apt -qq update && \
    apt -qq install -y --no-install-recommends \
        git \
        aria2 \
        wget \
        curl \
        busybox \
        unzip \
        tar \
        ffmpeg \
        gnupg2 \
        software-properties-common && \
    apt-add-repository non-free && \
    curl https://rclone.org/install.sh | bash && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add - && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && \
    apt -qq update && \
    apt -qq install -y --no-install-recommends \
        unrar && \
    apt purge -y software-properties-common && \
    apt clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN mkdir -p /app/gautam && \
    wget -O /app/gautam/gclone.gz https://git.io/JJMSG && \
    gzip -d /app/gautam/gclone.gz && \
    chmod 0775 /app/gautam/gclone

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash","start.sh"]
