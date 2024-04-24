FROM ubuntu:jammy AS builder

RUN apt-get update && apt-get install -y git build-essential curl wget golang

WORKDIR /usr/src

# Clone the kepubify source code from the Github repository
RUN git clone https://github.com/pgaskin/kepubify \
    && cd kepubify \
    && go build ./cmd/kepubify

FROM ubuntu:latest AS release

# Copy the kepubify binary from the builder stage
COPY --from=builder /usr/src/kepubify/kepubify /usr/local/bin

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive TZ="America\Los_Angeles" \ 
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY scripts /home/kepubify
WORKDIR /home/kepubify
ENTRYPOINT ["/bin/bash", "/home/kepubify/entrypoint.sh"]
