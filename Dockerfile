FROM nginx
MAINTAINER Nestor Chan (Original: Gary Louis Stewart)
COPY nginx.conf /etc/nginx/nginx.conf

ADD src/ /var/www

EXPOSE 8181

