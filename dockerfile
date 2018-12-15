FROM node:6.15.1-alpine

RUN apk update; apk add bash

RUN npm install docsify-cli

COPY _media/ ./app/_media
COPY config/ ./app/config
COPY vendor/ ./app/vendor
COPY *.md ./app/
COPY .nojekyll ./app/
COPY *.css ./app/
COPY *.html ./app/

CMD ["docsify", "serve", "./app"]
