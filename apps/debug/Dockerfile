FROM ubuntu:22.04

RUN apt-get update && \
    # Install dependencies
    apt-get install -y wget curl gnupg iproute2 net-tools && \
    # Add MongoDB repository
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
    --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org=8.0.4 mongodb-org-database=8.0.4 mongodb-org-server=8.0.4 mongodb-mongosh mongodb-org-mongos=8.0.4 mongodb-org-tools=8.0.4 && \
    # Install jq
    curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /usr/local/bin/jq
