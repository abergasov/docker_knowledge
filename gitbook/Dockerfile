FROM node:10-alpine
COPY book.json custom_style.css /srv/gitbook/
ADD copy_repo /srv/gitbook
RUN npm install --global gitbook-cli \
        && gitbook fetch 3.2.3 \
        && npm cache verify \
        && gitbook init \
        && rm -rf /tmp/*

EXPOSE 4000 35729
CMD gitbook install && gitbook serve