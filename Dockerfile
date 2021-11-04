FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY src/ /var/www

EXPOSE 8181

