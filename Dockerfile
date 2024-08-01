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

WORKDIR /usr/src/

# Copy package.json and package-lock.json
COPY package*.json /usr

# # Clean npm cache and node_modules
RUN npm cache clean --force && rm -rf node_modules && rm -f package-lock.json

# # Install npm dependencies including Puppeteer
RUN npm i

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && chown -R pptruser:pptruser /usr/src /usr/bin \
    && chmod -R 777 /usr/src /usr/bin

# Create directories for Maven and SBT
RUN mkdir -p /.m2/repository /.sbt 

# Ensure permissions are correct
RUN chown -R pptruser:pptruser /.m2 /.sbt
RUN chmod -R 777 /.m2 /.sbt

# Run everything after as non-privileged user.
USER pptruser

