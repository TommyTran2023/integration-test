FROM node:current-alpine3.19

RUN apk update \
    && apk add openjdk20 \
    && apk add maven \
    && apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV XDG_CONFIG_HOME=/tmp/.chromium
ENV XDG_CACHE_HOME=/tmp/.chromium

WORKDIR /usr/src/

# Copy package.json and package-lock.json
COPY package*.json ./

RUN npm install

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && chown -R pptruser:pptruser /usr/src \
    && chmod -R 777 /usr/src

# Create directories for Maven and SBT
RUN mkdir -p /.m2/repository /.sbt 

# Ensure permissions are correct
RUN chown -R pptruser:pptruser /.m2 /.sbt
RUN chmod -R 777 /.m2 /.sbt

# Run everything after as non-privileged user.
USER pptruser

