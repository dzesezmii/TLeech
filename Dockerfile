FROM python:3.8-slim-buster

WORKDIR /app

ENV PIP_NO_CACHE_DIR 1

# fix "ephimeral" / "AWS" file-systems
RUN sed -i.bak 's/us-west-2\.ec2\.//' /etc/apt/sources.list
ENV LANG C.UTF-8
ENV TZ=Europe/London

RUN apt -qq update && \
    DEBIAN_FRONTEND=noninteractive apt -qq install -y --no-install-recommends \
    git aria2 wget curl busybox unzip tar ffmpeg gnupg2 \
    software-properties-common && \
    apt clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-add-repository non-free && \
    curl https://rclone.org/install.sh | bash
    
RUN wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add - && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && \
    apt -qq update && \
    DEBIAN_FRONTEND=noninteractive apt -qq install -y unrar && \
    DEBIAN_FRONTEND=noninteractive apt purge -y software-properties-common && \
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
