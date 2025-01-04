# Used Nginx image
FROM nginx:alpine


WORKDIR /usr/share/nginx/html


COPY index.html /usr/share/nginx/html/


COPY images /usr/share/nginx/html/images/

EXPOSE 8585

CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
