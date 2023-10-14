FROM nginx:1.25-alpine

COPY ./startup.sh /
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf.template /etc/nginx/conf.d/


RUN apk add --no-cache bash=5.2.15-r5

RUN mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/proxy_temp && \
    mkdir -p /var/cache/nginx/fastcgi_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp && \
    mkdir -p /var/cache/nginx/scgi_temp && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /etc/nginx/ && \
    chmod -R 755 /etc/nginx/ && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /startup.sh && \
    chmod -R 755 /startup.sh

RUN mkdir -p /etc/nginx/ssl/ && \
    chown -R nginx:nginx /etc/nginx/ssl/ && \
    chmod -R 755 /etc/nginx/ssl/

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /run/nginx.pid

USER nginx:nginx

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=2 CMD curl -s -i http://localhost:80/ -A "HealthCheck: Docker/1.0" | head -1 || exit 1

CMD ["/bin/bash", "-c", "/startup.sh"]
