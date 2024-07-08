FROM node:latest
RUN apt-get update \
     && apt-get install default-jre -y \
     && apt-get install default-jdk -y \
     && apt-get install maven -y \
     && npm i puppeteer

WORKDIR /usr/src/