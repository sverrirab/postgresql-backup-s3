FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        postgresql-client \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/awscli/

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "aws.zip" \
    && unzip "aws.zip" \
    && /tmp/awscli/aws/install && rm -rf /tmp/awscli/*

WORKDIR /root

ADD backup.sh .

ENTRYPOINT ./backup.sh

