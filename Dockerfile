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

RUN npm i puppeteer

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && chown -R pptruser:pptruser /usr/src \
    && chmod -R 777 /usr/src

# Create directories for Maven and SBT
RUN mkdir -p /usr/src/.m2/repository /usr/src/.sbt 

# Ensure permissions are correct
RUN chown -R pptruser:pptruser /usr/src/.m2 
RUN chmod -R 777 /usr/src/.m2 
RUN chmod -R 777 /home/pptruser

# Run everything after as non-privileged user.
USER pptruser

