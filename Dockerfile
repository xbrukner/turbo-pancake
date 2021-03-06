# Base image
FROM nginx
# Set shell to properly run opensll
SHELL ["/bin/bash", "-c"]
# Copy content into nginx
COPY content /usr/share/nginx/html
# Install openssl
RUN apt-get update && apt-get install openssl
# Create SSL certificate
RUN openssl req -x509 \
        -out /etc/ssl/certs/localhost.crt -keyout /etc/ssl/private/localhost.key \
        -newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT \
        -config <( printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
# Copy new configuration
COPY configuration /etc/nginx/conf.d
