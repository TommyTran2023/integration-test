FROM node:current-alpine3.19

RUN apk update \
    && apk add openjdk20 \
    && apk add maven curl unzip bash \
    && apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont

# Install SBT
RUN mkdir -p /usr/src/.sbt && \
    mkdir -p /usr/src/.ivy2 && \
    curl -L -o /tmp/sbt.zip https://github.com/sbt/sbt/releases/download/v1.5.5/sbt-1.5.5.zip && \
    unzip /tmp/sbt.zip -d /usr/src/.sbt && \
    rm /tmp/sbt.zip

RUN ls /usr/src/.sbt/sbt -la

ENV SBT_OPTS="-Dsbt.global.base=/usr/src/.sbt/sbt -Dsbt.ivy.home=/usr/src/.ivy2"

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /usr/src/

RUN npm i puppeteer

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && chown -R pptruser:pptruser /usr/src \
    && chmod -R 777 /usr/src

# Run everything after as non-privileged user.
USER pptruser

