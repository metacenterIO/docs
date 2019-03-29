FROM littlstar/docker-docsify

COPY _media/ /usr/local/docsify/_media
COPY config/ /usr/local/docsify/config
COPY vendor/ /usr/local/docsify/vendor
COPY *.md /usr/local/docsify/
COPY .nojekyll /usr/local/docsify/
COPY *.css /usr/local/docsify/
COPY *.html /usr/local/docsify/
