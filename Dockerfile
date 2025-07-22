# Stage 1: Builder
FROM python:3.12-bookworm AS builder
WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y curl bzip2 && \
    curl -L -o goose.tar.bz2 https://github.com/block/goose/releases/download/stable/goose-x86_64-unknown-linux-gnu.tar.bz2 && \
    tar -xjf goose.tar.bz2 -C /usr/local/bin && \
    chmod +x /usr/local/bin/goose && \
    rm -rf /var/lib/apt/lists/* goose.tar.bz2

# Stage 2: Runtime
FROM python:3.12-slim
WORKDIR /root/workspace

RUN apt-get update && \
    apt-get install -y libxcb1 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/goose /usr/local/bin/goose

ENV PATH="/usr/local/bin:$PATH"
