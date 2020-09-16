FROM python:3.8-slim-buster

RUN mkdir ./app && \
    chmod 777 ./app
WORKDIR /app

ENV TZ=Europe/London

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y git aria2 wget curl busybox unzip tar ffmpeg && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add - && \
    echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list && \
    apt-get update && \
    apt-get -qq install -y unrar && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl https://rclone.org/install.sh | bash

RUN mkdir /app/gautam && \
    wget -O /app/gautam/gclone.gz https://git.io/JJMSG && \
    gzip -d /app/gautam/gclone.gz && \
    chmod 0775 /app/gautam/gclone

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash","start.sh"]
