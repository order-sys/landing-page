FROM nginxinc/nginx-unprivileged:1.27-alpine-slim

# Copy site content
COPY index.html /usr/share/nginx/html/index.html
COPY assets/   /usr/share/nginx/html/assets/

# Custom nginx config: listen on 8080 (unprivileged port), serve from default html root
RUN printf 'server {\n\
    listen 8080;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location / {\n\
        try_files $uri $uri/ =404;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 8080
