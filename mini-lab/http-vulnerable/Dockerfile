FROM nginx:alpine

RUN apk add --no-cache apache2-utils

# Create htpasswd file with WEAK credentials present in wordlists/passwords.txt
RUN htpasswd -c -b /etc/nginx/.htpasswd admin admin

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
