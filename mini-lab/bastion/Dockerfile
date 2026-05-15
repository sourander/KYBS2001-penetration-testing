# --- Builder image ---
FROM alpine:latest AS builder

RUN apk add --no-cache curl tar
RUN curl -fsSL \
        "https://github.com/praetorian-inc/brutus/releases/latest/download/brutus-linux-amd64.tar.gz" \
    | tar xz -C /tmp/ && \
    chmod +x /tmp/brutus

# --- Final image ---
FROM alpine:latest
COPY --from=builder /tmp/brutus /usr/local/bin/brutus

RUN apk add --no-cache bash ca-certificates

COPY wordlists/ /wordlists/
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Keep container alive
CMD ["sleep", "infinity"]